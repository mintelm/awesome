local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local double_click_event_handler = function(double_click_event)
	if double_click_timer then
		double_click_timer : stop()
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

local create_click_events = function(c)
	-- Titlebar button/click events
	local buttons = gears.table.join(
		awful.button(
			{},
			1,
			function()
				double_click_event_handler(function()
					if c.floating then
						c.floating = false
						return
					end
					c.maximized = not c.maximized
					c : raise()
					return
				end)
				c : activate { context = 'titlebar', action = 'mouse_move' }
			end
		),
		awful.button(
			{},
			3,
			function()
				c : activate { context = 'titlebar', action = 'mouse_resize' }
			end
		)
	)

	return buttons
end

local top_titlebar = function(c)
    local titlebar = awful.titlebar(
        c,
        {
            size = beautiful.titlebar_size
        }
    )

    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c : activate { context = 'titlebar', action = 'mouse_move'  }
        end),
        awful.button({ }, 3, function()
            c : activate { context = 'titlebar', action = 'mouse_resize'}
        end),
    }

    titlebar : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = create_click_events(c),
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = create_click_events(c),
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end

return top_titlebar
