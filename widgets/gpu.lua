local awful = require("awful")
local wibox = require("wibox")

local gfs = require("gears.filesystem")
local icon_path = gfs.get_configuration_dir() .. "/icons/widgets/"


local icon_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(_, 6, 6, 4, 4),
}

local gpu_widget = wibox.widget {
    icon_widget,
    layout = wibox.layout.fixed.horizontal,
}

cmd = "glxinfo | grep NVIDIA"
awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
    if stdout == nil or stdout == '' then
        icon_widget.icon:set_image(icon_path .. "intel.svg")
    else
        icon_widget.icon:set_image(icon_path .. "nvidia.svg")
    end
end)


return gpu_widget
