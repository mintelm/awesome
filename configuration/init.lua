local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')
local gears = require('gears')
local defaults = require('configuration.defaults')

require('configuration.bling')
require('configuration.windows')
require('configuration.keybinds')
require('modules.top_panel')

local function set_default_layout(s)
    local layout = defaults.layouts[1]
    if s == screen.primary then
        layout = defaults.layouts[0]
    end
    awful.tag(defaults.tags, s, layout)
end

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

awful.screen.connect_for_each_screen(function(s)
    set_default_layout(s)
    set_wallpaper(s)
end)

-- auto start stuff
for _, app in ipairs(defaults.auto_start) do
    local function run_once(cmd)
        local binary = cmd
        local firstspace = cmd:find(' ')

        if firstspace then
            binary = cmd:sub(0, firstspace - 1)
        end

        awful.spawn.easy_async_with_shell(
            -- if no process with binary exists, start command
            string.format('pgrep -u $USER -x %s > /dev/null || (%s)', binary, cmd),
            function(_, stderr)
                -- Debugger
                if not stderr or stderr == '' then
                    return
                end
                naughty.notification({
                    app_name = 'Start-up Applications',
                    title = '<b>Oof! Error detected when starting an application!</b>',
                    message = stderr:gsub('%\n', ''),
                    timeout = 20,
                    icon = require('beautiful').awesome_icon
                })
            end
        )
    end

    run_once(app)
end
