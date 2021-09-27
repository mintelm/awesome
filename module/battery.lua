local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local battery_path = '/sys/class/power_supply/BAT0/'
local crit_threshold = 15
local warningSent = false

local textbox = wibox.widget {
    text = 'BAT',
    valign = 'center',
    align = 'center',
    widget = wibox.widget.textbox,
}
local arcchart = wibox.widget {
    max_value = 100,
    value = 100,
    thickness = 4,
    start_angle = -math.pi/2,
    bg = beautiful.inactive,
    widget = wibox.container.arcchart,
}
local function battery_warning()
    if not warningSent then
        naughty.notify({
            title = 'Warning',
            text = 'Battery capacity is below 15%.',
            preset = naughty.config.presets.critical,
        })
        warningSent = true
    end
end
local battery = wibox.widget {
    -- wrap textbox in margin
    {
        textbox,
        widget = wibox.container.margin,
        right = dpi(4),
    },
    -- wrap arcchart in mirror container
    {
        arcchart,
        reflection = { horizontal = true },
        widget = wibox.container.mirror,
    },
    layout = wibox.layout.fixed.horizontal,
    set_capacity = function(_, val)
        arcchart.value = val
        if tonumber(val) <= crit_threshold then
            battery_warning()
            arcchart.colors = { beautiful.xcolor1 }
        else
            arcchart.colors = { beautiful.fg }
        end
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
