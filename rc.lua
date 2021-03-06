-- {{{ Init
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local theme = require("beautiful")
theme.init("/home/mario/.config/awesome/theme.lua")
-- Notification library
local naughty = require("naughty")
-- Vicious + Widgets
local vicious = require("vicious")
local battery_widget = require("widgets.battery")
local pkg_widget = require("widgets.pkg")
local network_widget = require("widgets.network")
local cpu_widget = require("widgets.cpu")
local gpu_widget = require("widgets.gpu")

-- Autorun
awful.spawn.with_shell("~/.config/awesome/scripts/autorun.sh")
-- }}}


-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
terminal = "alacritty"
browser = "firefox"
explorer = "thunar"
calculator = "galculator"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
}
-- }}}


-- {{{ Wallpaper
local function set_wallpaper(s)
    if theme.wallpaper then
        local wallpaper = theme.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)
-- }}


-- {{{ Statusbar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock.font = theme.clock_font

-- Create mouse events for taglist
local taglist_buttons = awful.util.table.join(
                            awful.button({ }, 1, awful.tag.viewonly),
                            awful.button({ modkey }, 1, awful.client.movetotag),
                            awful.button({ }, 3, awful.tag.viewtoggle),
                            awful.button({ modkey }, 3, awful.client.toggletag),
                            awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                            awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                        )

-- Create mouse events for tasklist
local tasklist_buttons = awful.util.table.join(
                            awful.button({ }, 1, function (c)
                                                     if c == client.focus then
                                                         c.minimized = true
                                                     else
                                                         -- Without this, the following
                                                         -- :isvisible() makes no sense
                                                         c.minimized = false
                                                         if not c:isvisible() then
                                                             awful.tag.viewonly(c:tags()[1])
                                                         end
                                                         -- This will also un-minimize
                                                         -- the client, if needed
                                                         client.focus = c
                                                         c:raise()
                                                     end
                                                 end),
                            awful.button({ }, 3, function ()
                                                     if instance then
                                                         instance:hide()
                                                         instance = nil
                                                     else
                                                         instance = awful.menu.clients({ width=250 })
                                                     end
                                                 end),
                            awful.button({ }, 4, function ()
                                                     awful.client.focus.byidx(1)
                                                     if client.focus then client.focus:raise() end
                                                 end),
                            awful.button({ }, 5, function ()
                                                     awful.client.focus.byidx(-1)
                                                     if client.focus then client.focus:raise() end
                                                 end))

-- Add tags and statusbar to each screen
awful.screen.connect_for_each_screen(function(s)
    -- Add tags
    awful.tag.add("", {
        icon     = awful.util.get_configuration_dir() .. "icons/tags/code-braces-colored.png",
        layout   = layouts[2],
        selected = true,
        screen   = s,
    })
    awful.tag.add("", {
        icon     = awful.util.get_configuration_dir() .. "icons/tags/firefox-colored.png",
        layout   = layouts[2],
        screen   = s,
    })
    awful.tag.add("", {
        icon     = awful.util.get_configuration_dir() .. "icons/tags/text-file-colored.png",
        layout   = layouts[2],
        screen   = s,
    })
    awful.tag.add("", {
        icon     = awful.util.get_configuration_dir() .. "icons/tags/flask-colored.png",
        layout   = layouts[2],
        screen   = s,
    })

    -- Create layoutbox
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create taglist
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create tasklist
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }


    -- Create seperator widget
    local vert_sep = wibox.widget {
        widget = wibox.widget.separator,
        orientation = "vertical",
        forced_width = 10,
        color = theme.fg_normal
    }

    local systray = wibox.widget{
        {
            {
                widget = wibox.widget.systray(),
            },
            layout = wibox.container.margin(_, 6, 6, 0, 0),
        },
        {
            {
                widget = vert_sep,
            },
            layout = awful.widget.only_on_screen,
            screen = "primary",
        },
        layout = wibox.layout.fixed.horizontal,
    }

    -- Create statusbar
    s.statusbar= awful.wibar({ position = "top", screen = s, bg = theme.wibar_bg, height = theme.wibar_height})
    s.statusbar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
        -- { Middle widget
            s.mytasklist,
        -- }
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            pkg_widget,
            vert_sep,
            network_widget.down_widget,
            vert_sep,
            network_widget.up_widget,
            vert_sep,
            gpu_widget,
            vert_sep,
            cpu_widget,
            vert_sep,
            battery_widget,
            vert_sep,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}


-- {{{ Key bindings
globalkeys = gears.table.join(
    -- General
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "o", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ "Mod1" }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey,           }, "m", function () awful.layout.inc(layouts,  1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "m", function () awful.layout.inc(layouts, -1) end,
              {description = "select previous", group = "layout"}),

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open terminal", group = "launcher"}),
    awful.key({ modkey,           }, "w", function () awful.spawn(browser) end,
              {description = "open firefox", group = "launcher"}),
    awful.key({ modkey,           }, "e", function () awful.spawn(explorer) end,
              {description = "open fileexplorer", group = "launcher"}),
    awful.key({ modkey,           }, "c", function () awful.spawn(calculator) end,
              {description = "open calculator", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.spawn("rofi -show run -theme gruvbox.rasi -lines 7") end,
              {description = "open prompt", group = "launcher"}),
    awful.key({ modkey,           }, "p", function () awful.spawn("scrot") end,
              {description = "take screenshot", group = "launcher"}),

    -- Sound
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 5%+") end,
              {description = "increase volume", group = "sound"}),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 5%-") end,
              {description = "decrease volume", group = "sound"}),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle") end,
              {description = "(un)mute volume", group = "sound"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("brightnessctl s 10%+") end,
              {description = "increase brightness", group = "screen"}),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("brightnessctl s 10%-") end,
              {description = "decrease brightness", group = "screen"})
)

-- client manipulation
-- Resizes client based on layout
local function client_resize (key, c)
    if c == nil then
        c = client.focus
    end

    local layout = awful.layout.get(c.screen)

    if c.floating then
        if     key == "Up"    then c:relative_move(0, 0, 0, -5)
        elseif key == "Down"  then c:relative_move(0, 0, 0, 5)
        elseif key == "Right" then c:relative_move(0, 0, 5, 0)
        elseif key == "Left"  then c:relative_move(0, 0, -5, 0)
        end
    elseif layout == awful.layout.suit.tile then
        if     key == "Up"    then awful.client.incwfact(-0.05)
        elseif key == "Down"  then awful.client.incwfact(0.05)
        elseif key == "Right" then awful.tag.incmwfact(0.05)
        elseif key == "Left"  then awful.tag.incmwfact(-0.05)
        end
    elseif layout == awful.layout.suit.tile.bottom then
        if     key == "Up"  then awful.tag.incmwfact(-0.05)
        elseif key == "Down" then awful.tag.incmwfact(0.05)
        elseif key == "Left"  then awful.client.incwfact(0.05)
        elseif key == "Right"    then awful.client.incwfact(-0.05)
        end
    elseif layout == awful.layout.suit.fair then
        if     key == "Up"    then awful.client.incwfact(-0.05)
        elseif key == "Down"  then awful.client.incwfact(0.05)
        elseif key == "Right" then awful.tag.incmwfact(0.05)
        elseif key == "Left"  then awful.tag.incmwfact(-0.05)
        end
    end
end

clientkeys = gears.table.join(
    awful.key({ modkey }, "j", function () awful.client.focus.bydirection("down")
              if client.focus then client.focus:raise() end end,
              {description = "focus client underneath", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.bydirection("up")
              if client.focus then client.focus:raise() end end,
              {description = "focus client above", group = "client"}),
    awful.key({ modkey }, "h", function () awful.client.focus.bydirection("left")
              if client.focus then client.focus:raise() end end,
              {description = "focus client to the left", group = "client"}),
    awful.key({ modkey }, "l", function () awful.client.focus.bydirection("right")
              if client.focus then client.focus:raise() end end,
              {description = "focus client to the right", group = "client"}),
    awful.key({ modkey, "Shift"   }, "h",     function () client_resize('Left') end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "j",     function () client_resize('Down') end,
              {description = "increase client height factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "k",     function () client_resize('Up')   end,
              {description = "decrease client height factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () client_resize('Right') end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "space",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen() end,
              {description = "move to next screen", group = "client"})
)

-- Bind all key numbers to tags.
for i = 1, 4 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         tag:view_only()
                      end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

-- Mouse Bindings
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = { border_width = theme.border_width,
                       border_color = theme.border_normal,
                       focus = awful.client.focus.filter,
                       raise = true,
                       keys = clientkeys,
                       buttons = clientbuttons,
                       screen = awful.screen.preferred,
                       placement = awful.placement.no_overlap+awful.placement.no_offscreen
                     }
    },
    {
        rule_any = {
            class = {
              "Gpick",
              "Tor Browser",
              "Galculator",
            },
            role = {
              "pop-up",
            }
        },
        properties = { floating = true, placement = awful.placement.centered }
    },
}
-- }}}


-- {{{ Signals
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set new windows to slave stack instead of master
client.connect_signal("manage", function (c)
    c.maximized = false
    if not awesome.startup then
        awful.client.setslave(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Draw border on focus
client.connect_signal("focus", function(c) c.border_color = theme.border_focus end)

-- Hide border on unfocus
client.connect_signal("unfocus", function(c) c.border_color = theme.border_normal end)
-- }}}
