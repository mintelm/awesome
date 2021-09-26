local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi
local awful = require('awful')
local gears = require('gears')

local battery_path = '/sys/class/power_supply/BAT0/'

local iconbox = wibox.widget {
    image = beautiful.layout_tile,
    widget = wibox.widget.imagebox,
}
local textbox = wibox.widget {
    text = '100%',
    widget = wibox.widget.textbox,
}

local battery = wibox.widget {
    {
        textbox,
        right = dpi(4),
        widget = wibox.container.margin,
    },
    iconbox,
    layout = wibox.layout.fixed.horizontal,
    set_capacity = function(_, val)
        textbox.text = tonumber(val) .. '%'
    end,
}

-- Update widget content every 10s
gears.timer {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            { 'cat', battery_path .. 'capacity' },
            function(stdout)
                battery.capacity = stdout
            end
        )
    end,
}

return battery
