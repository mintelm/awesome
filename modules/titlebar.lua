local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local dpi = require("beautiful.xresources").apply_dpi

local shapes = require('modules.shapes')

local titlebar = {}

local function create_click_events(c)
    -- Double click titlebar
    function double_click_event_handler(double_click_event)
        if double_click_timer then
            double_click_timer:stop()
            double_click_timer = nil
            return true
        end

        double_click_timer = gears.timer.start_new(0.20, function()
            double_click_timer = nil
            return false
        end)
    end

    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            if double_click_event_handler() then
                c.maximized = not c.maximized
                c:raise()
            else
                awful.mouse.client.move(c)
            end
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    return buttons
end

local function create_title_button(c, color_focus, color_unfocus, shape)
    local title_button = wibox.widget {
        forced_width = dpi(12),
        forced_height = dpi(12),
        bg = color_focus,
        shape = shape,
        widget = wibox.container.background
    }

    local update = function()
        if client.focus == c then
            title_button.bg = color_focus
        else
            title_button.bg = color_unfocus
        end
    end

    update()

    c:connect_signal('focus', update)
    c:connect_signal('unfocus', update)

    title_button:connect_signal('mouse::enter', function() title_button.bg = color_focus .. '70' end)
    title_button:connect_signal('mouse::leave', function() title_button.bg = color_focus end)

    return title_button
end

local function update_border(c, widget)
    if c.maximized then
        widget.bg = beautiful.border_normal
        widget.shape = shapes.rrect(0)
    elseif client.focus == c then
        widget.bg = beautiful.border_focus
        widget.shape = shapes.prrect(beautiful.border_radius, true, true, false, false)
    else
        widget.bg = beautiful.border_normal
        widget.shape = shapes.prrect(beautiful.border_radius, true, true, false, false)
    end
end

local function border(c)
    local border = wibox.widget {
        bg = beautiful.xcolor0,
        widget = wibox.container.background
    }

    c:connect_signal('focus', function() update_border(c, border) end)
    c:connect_signal('unfocus', function() update_border(c, border) end)
    c:connect_signal('property::maximized', function() update_border(c, border) end)

    return border
end

local function top(c)
    local powerline_depth = math.floor(0.42 * beautiful.titlebar_icon_size)
    local icon_size = beautiful.titlebar_icon_size

    local powerline = function(depth)
        return shapes.powerline(icon_size, icon_size, depth)
    end

    local hexagon = function()
        return shapes.hexagon(icon_size, icon_size)
    end

    local square = function()
        return function(cr)
            gears.shape.partially_rounded_rect(cr, icon_size, icon_size, tl, tr, br, bl, 0)
        end
    end

    local ontop = create_title_button(c, beautiful.xcolor3, beautiful.xcolor8, hexagon())
    ontop:connect_signal('button::release', function() c.ontop = not c.ontop end)
    client.connect_signal(
        'property::ontop',
        function()
            if c.ontop then
                ontop.shape = shapes.circle(icon_size, icon_size)
            else
                ontop.shape = hexagon()
            end
        end
    )

    -- local min = create_title_button(c, beautiful.xcolor3, beautiful.xcolor8, powerline(powerline_depth))
    -- min:connect_signal('button::release', function() c.minimized = true end)

    local max = create_title_button(c, beautiful.xcolor6, beautiful.xcolor8, powerline(powerline_depth))
    max:connect_signal('button::release', function() c.maximized = not c.maximized end)
    client.connect_signal(
        'property::maximized',
        function()
            if c.maximized then
                max.shape = square()
            else
                max.shape = powerline(powerline_depth)
            end
        end
    )

    local close = create_title_button(c, beautiful.xcolor1, beautiful.xcolor8, powerline(powerline_depth))
    close:connect_signal('button::release', function() c : kill() end)

    local titlebar = wibox.widget {
        { -- Left
            awful.widget.clienticon(c),
            top = dpi(2),
            bottom = dpi(2),
            left = dpi(2),
            buttons = create_click_events(c),
            widget = wibox.container.margin
        },
        { -- Middle
            { -- Title
                align = 'center',
                valign = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = create_click_events(c),
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                ontop,
                -- min,
                max,
                close,
                spacing = dpi(0),
                layout = wibox.layout.flex.horizontal
            },
            top = dpi(7),
            left = dpi(5),
            right = dpi(2),
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }

    -- wrap titlebar in a border
    local top = border(c)
    top:setup({
        {
            titlebar,
            bg = beautiful.xbg,
            shape = shapes.prrect(beautiful.border_radius, true, true, false, false),
            widget = wibox.container.background
        },
        top = beautiful.border_width,
        left = beautiful.border_width,
        right = beautiful.border_width,
        widget = wibox.container.margin
    })

    return top
end

function titlebar.set_decoration(c)
    awful.titlebar(c, {
            position = 'top',
            size = beautiful.titlebar_size,
            bg = 'transparent',
    }):setup { top(c), layout = wibox.layout.flex.horizontal }

    awful.titlebar(c, {
            position = 'bottom',
            size = beautiful.border_width,
            bg = 'transparent',
    }):setup { border(c), layout = wibox.layout.flex.horizontal }

    awful.titlebar(c, {
            position = 'left',
            size = beautiful.border_width
    }):setup { border(c), layout = wibox.layout.flex.horizontal }

    awful.titlebar(c, {
            position = 'right',
            size = beautiful.border_width
    }):setup { border(c), layout = wibox.layout.flex.horizontal }
end

-- add to tag signal: 'property::layout'
-- and to client signal: 'tagged'
function titlebar.dynamic_titlebar(c)
    if c.floating or c.first_tag.layout.name == 'floating' then
        awful.titlebar.show(c, 'top')
        awful.titlebar.show(c, 'bottom')
        awful.titlebar.show(c, 'left')
        awful.titlebar.show(c, 'right')
        c.border_width = dpi(0)
    else
        awful.titlebar.hide(c, 'top')
        awful.titlebar.hide(c, 'bottom')
        awful.titlebar.hide(c, 'left')
        awful.titlebar.hide(c, 'right')
        c.border_width = beautiful.border_width
    end

    -- resize if last layout was not floating to compensate for titlebar.show
    if c.last_layout ~= 'floating' and c.last_layout ~= nil then
        local acc_size = beautiful.titlebar_size - beautiful.border_width
        c:relative_move(0, 0, 0, - acc_size)
        -- kitty titlebar 'folds' up while others 'fold' down ..
        if c.class == 'kitty' then
            c:relative_move(0, acc_size, 0, 0)
        end
        if c.class == 'Gnome-terminal' then
            c:relative_move(0, 0, 0, acc_size)
        end
    end

    c.last_layout = c.first_tag.layout.name
end

return titlebar
