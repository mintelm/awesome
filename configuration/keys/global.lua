local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')

local modkey = require('configuration.keys.mod').mod_key
local apps = require('configuration.apps')

awful.keyboard.append_global_keybindings({
    -- group = awesome
    awful.key(
        { modkey },
        'F1',
        hotkeys_popup.show_help,
        { description = 'show help', group = 'awesome' }
    ),
    awful.key(
        { modkey, 'Control' },
        'r',
        awesome.restart,
        { description = 'reload awesome', group = 'awesome' }
    ),
    awful.key(
        { modkey, 'Control' },
        'q',
        awesome.quit,
        { description = 'quit awesome', group = 'awesome' }
    ),

    -- group = client
    awful.key(
        { modkey },
        'j',
        function ()
            awful.client.focus.byidx(1)
        end,
        { description = 'focus next by index', group = 'client' }
    ),
    awful.key(
        { modkey },
        "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = 'focus previous by index', group = 'client' }
    ),
    awful.key(
        { modkey, 'Shift' },
        'j',
        function ()
            awful.client.swap.byidx(1)
        end,
       { description = 'swap with next client by index', group = 'client' }
   ),
    awful.key(
        { modkey, 'Shift' },
        'k',
        function ()
            awful.client.swap.byidx(-1)
        end,
       { description = 'swap with previous client by index', group = 'client' }
   ),

    -- group = tag
    awful.key {
        modifiers = { modkey },
        keygroup = 'numrow',
        description = 'view tag',
        group = 'tag',
        on_press = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup = 'numrow',
        description = 'move focused client to tag',
        group = 'tag',
        on_press = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    -- group = layout
    awful.key(
        { modkey },
        'l',
        function()
            awful.tag.incmwfact(0.05)
        end,
        { description = 'increase master width factor', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'h',
        function()
            awful.tag.incmwfact(-0.05)
        end,
        { description = 'decrease master width factor', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'a',
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        { description = 'increase the number of master clients', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'x',
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = 'decrease the number of master clients', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'v',
        function()
            select_layout(awful.layout.suit.tile)
        end,
        { description = 'set layout to `tile`', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'b',
        function()
            select_layout(awful.layout.suit.tile.bottom)
        end,
        { description = 'set layout to `tile bottom`', group = 'layout' }
    ),
    awful.key(
        { modkey },
        'n',
        function()
            select_layout(awful.layout.suit.floating)
        end,
        { description = 'set layout to `floating`', group = 'layout' }
    ),

    -- group = screen
    awful.key(
        { modkey },
        ',',
        function()
            awful.screen.focus_relative(1)
        end,
        { description = 'focus the next screen', group = 'screen' }
    ),
    awful.key(
        { modkey },
        '.',
        function()
            awful.screen.focus_relative(-1)
        end,
        { description = 'focus the previous screen', group = 'screen' }
    ),

    -- group = launcher
    awful.key(
        { modkey },
        'Return',
        function()
            awful.spawn(apps.default.terminal)
        end,
        { description = 'open default terminal', group = 'launcher' }
    ),
    awful.key(
        { modkey },
        'space',
        function()
            awful.spawn(apps.default.run_menu)
        end,
        { description = 'open default run menu', group = 'launcher' }
    )
})

function select_layout(l)
    local t = awful.screen.focused().selected_tag
    if t then
        t.layout = l
    end
end
