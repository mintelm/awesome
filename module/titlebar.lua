local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local shapes = require('module.shapes')

local titlebar = {}

local function create_click_events(c)
    local double_click_event_handler = function(double_click_event)
        if double_click_timer then
            double_click_timer:stop()
            double_click_timer = nil
            double_click_event()
            return
        end

        double_click_timer = gears.timer.start_new(
            0.20,
            function()
                double_click_timer = nil
                return false
            end
        )
    end

    local click_event = function()
        if c.floating then
            c.floating = false
            return
        end
        c.maximized = not c.maximized
        c:raise()
        return
    end

	local buttons = gears.table.join(
		awful.button(
			{},
			1,
			function()
				double_click_event_handler(click_event)
				c:activate { context = 'titlebar', action = 'mouse_move' }
			end
		),
		awful.button(
			{},
			3,
			function()
				c:activate { context = 'titlebar', action = 'mouse_resize' }
			end
		)
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

function titlebar.top_titlebar(c)
    local powerline_depth = math.floor(0.42 * beautiful.titlebar_icon_size)
    local icon_size = beautiful.titlebar_icon_size

    local powerline = function(depth)
        return shapes.powerline(icon_size, icon_size, depth)
    end

    local hexagon = function()
        return shapes.hexagon(icon_size, icon_size)
    end

    local ontop = create_title_button(c, beautiful.xcolor4, beautiful.xcolor8, hexagon())
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

    local min = create_title_button(c, beautiful.xcolor3, beautiful.xcolor8, powerline(powerline_depth))
    min:connect_signal('button::release', function() c.minimized = true end)

    local max = create_title_button(c, beautiful.xcolor6, beautiful.xcolor8, powerline(powerline_depth))
    max:connect_signal('button::release', function() c.maximized = not c.maximized end)
    client.connect_signal(
        'property::maximized',
        function()
            if c.maximized then
                max.shape = powerline(0)
            else
                max.shape = powerline(powerline_depth)
            end
        end
    )

    local close = create_title_button(c, beautiful.xcolor1, beautiful.xcolor8, powerline(powerline_depth))
    close:connect_signal('button::release', function() c : kill() end)

    awful.titlebar(c, { size = beautiful.titlebar_size, bg = beautiful.xbg }):setup {
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
                min,
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
end

function titlebar.dynamic_titlebar(c)
    if c.floating or c.first_tag.layout.name == 'floating' then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end

    -- resize if last layout was not floating to compensate for titlebar.show
    if c.last_layout ~= 'floating' then
        c:relative_move(0, 0, 0, - beautiful.titlebar_size)
        -- kitty titlebar 'folds' up while others 'fold' down ..
        if c.class == 'kitty' then
            c:relative_move(0, beautiful.titlebar_size, 0, 0)
        end
        if c.class == 'Gnome-terminal' then
            c:relative_move(0, 0, 0, beautiful.titlebar_size)
        end
    end

    c.last_layout = c.first_tag.layout.name
end

return titlebar
