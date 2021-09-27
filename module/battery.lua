local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi
local awful = require('awful')
local gears = require('gears')

local battery_path = '/sys/class/power_supply/BAT0/'

local textbox = wibox.widget {
    text = 'BAT',
    valign = 'center',
    align = 'center',
    widget = wibox.widget.textbox,
}
local arcchart = wibox.widget {
    max_value = 100,
    value = 50,
    thickness = 4,
    rounded_edge = true,
    start_angle = math.pi/2,
    widget = wibox.container.arcchart,
}
local battery = wibox.widget {
    {
        textbox,
        widget = wibox.container.margin,
        right = dpi(4)
    },
    arcchart,
    layout = wibox.layout.fixed.horizontal,
    set_capacity = function(_, val)
        arcchart.value = val
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
