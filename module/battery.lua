local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful.xresources').apply_dpi
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local battery_path = '/sys/class/power_supply/BAT0/'
local crit_threshold = 15
local medium_threshold = 40
local warning_sent = false

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
    if not warning_sent then
        naughty.notify({
            title = 'Warning',
            text = 'Battery capacity is below 15%.',
            preset = naughty.config.presets.critical,
        })
        warning_sent = true
    end
end
local battery = wibox.widget {
    -- wrap textbox in margin
    {
        textbox,
        visible = false,
        right = dpi(4),
        widget = wibox.container.margin,
    },
    -- wrap arcchart in mirror container
    {
        arcchart,
        reflection = { horizontal = true },
        widget = wibox.container.mirror,
    },
    layout = wibox.layout.fixed.horizontal,
    set_info = function(_, val)
        local capacity, status

        for line in val:gmatch("([^\n]*)\n?") do
            if capacity == nil then
                capacity = tonumber(line)
            else
                status = string.lower(line)
            end
        end

        arcchart.value = capacity

        if status == 'charging' then
            arcchart.colors = { beautiful.xcolor10 }
            warning_sent = false
        elseif capacity <= crit_threshold then
            battery_warning()
            arcchart.colors = { beautiful.xcolor9 }
        elseif capacity <= medium_threshold then
            arcchart.colors = { beautiful.xcolor14 }
        else
            arcchart.colors = { beautiful.xfg }
        end
    end
}

-- Update widget content every 10s
gears.timer {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            { 'cat', battery_path .. 'capacity', battery_path .. 'status' },
            function(stdout)
                battery.info = stdout
            end
        )
    end,
}

return battery
