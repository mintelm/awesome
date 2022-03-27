local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')

local apps = require('configuration.defaults').apps

local mod_key = 'Mod4'
local alt_key = 'Mod1'

function select_layout(l)
    local t = awful.screen.focused().selected_tag
    if t then
        t.layout = l
    end
end

-- global binds
awful.keyboard.append_global_keybindings({
    -- group = awesome
    awful.key(
        { mod_key },
        'F1',
        hotkeys_popup.show_help,
        { description = 'show help', group = 'awesome' }
    ),
    awful.key(
        { mod_key, 'Control' },
        'r',
        awesome.restart,
        { description = 'reload awesome', group = 'awesome' }
    ),
    awful.key(
        { mod_key, 'Control' },
        'q',
        awesome.quit,
        { description = 'quit awesome', group = 'awesome' }
    ),
    -- group = client
    awful.key(
        { mod_key },
        'j',
        function ()
            awful.client.focus.byidx(1)
        end,
        { description = 'focus next by index', group = 'client' }
    ),
    awful.key(
        { mod_key },
        "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = 'focus previous by index', group = 'client' }
    ),
    awful.key(
        { mod_key, 'Shift' },
        'j',
        function ()
            awful.client.swap.byidx(1)
        end,
       { description = 'swap with next client by index', group = 'client' }
   ),
    awful.key(
        { mod_key, 'Shift' },
        'k',
        function ()
            awful.client.swap.byidx(-1)
        end,
       { description = 'swap with previous client by index', group = 'client' }
   ),
    awful.key(
        { alt_key },
        'Tab',
        function ()
            awesome.emit_signal('bling::window_switcher::turn_on')
            --alt_tab.switch( 1, alt_key, 'Alt_L', 'Shift', 'Tab')
        end,
        { description = 'window switcher', group = 'client' }
    ),
    -- group = tag
    awful.key {
        modifiers = { mod_key },
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
        modifiers = { mod_key, "Shift" },
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
        { mod_key },
        'l',
        function()
            awful.tag.incmwfact(0.05)
        end,
        { description = 'increase master width factor', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'h',
        function()
            awful.tag.incmwfact(-0.05)
        end,
        { description = 'decrease master width factor', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'a',
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        { description = 'increase the number of master clients', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'x',
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = 'decrease the number of master clients', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'v',
        function()
            select_layout(awful.layout.suit.tile)
        end,
        { description = 'set layout to `tile`', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'b',
        function()
            select_layout(awful.layout.suit.tile.bottom)
        end,
        { description = 'set layout to `tile bottom`', group = 'layout' }
    ),
    awful.key(
        { mod_key },
        'n',
        function()
            select_layout(awful.layout.suit.floating)
        end,
        { description = 'set layout to `floating`', group = 'layout' }
    ),
    -- group = screen
    awful.key(
        { mod_key },
        ',',
        function()
            awful.screen.focus_relative(1)
        end,
        { description = 'focus the next screen', group = 'screen' }
    ),
    awful.key(
        { mod_key },
        '.',
        function()
            awful.screen.focus_relative(-1)
        end,
        { description = 'focus the previous screen', group = 'screen' }
    ),
    -- group = launcher
    awful.key(
        { mod_key },
        'Return',
        function()
            awful.spawn(apps.terminal)
        end,
        { description = 'open default terminal', group = 'launcher' }
    ),
    awful.key(
        { mod_key },
        'space',
        function()
            awful.spawn(apps.run_menu)
        end,
        { description = 'open default run menu', group = 'launcher' }
    ),
})

-- keybinds that need client context
client.connect_signal('request::default_keybindings', function()
    awful.keyboard.append_client_keybindings({
        -- group = client
        awful.key(
            { mod_key},
            'w',
            function(c)
                c:kill()
            end,
            { description = 'close', group = 'client' }
        ),
        awful.key(
            { mod_key },
            'f',
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = 'toggle fullscreen', group = 'client' }
        ),
        awful.key(
            { mod_key },
            'm',
            function(c)
                c.maximized = not c.maximized
            end,
            { description = 'toggle fullscreen', group = 'client' }
        ),
        -- group = screen
        awful.key(
            { mod_key, 'Shift' },
            ',',
            function(c)
                c:move_to_screen()
            end,
            { description = 'move client to next screen', group = 'screen' }
        ),
        awful.key(
            { mod_key, 'Shift' },
            '.',
            function(c)
                c:move_to_screen(c.screen.index-1)
            end,
            { description = 'move client to previous screen', group = 'screen' }
        ),
    })
end
)

-- mouse settings
require('awful.autofocus')

client.connect_signal(
    'mouse::enter',
    function(c)
        c:activate { context = 'mouse_enter', raise = false }
    end
)

client.connect_signal(
    'request::default_mousebindings',
    function()
        awful.mouse.append_client_mousebindings({
            awful.button(
                { },
                1,
                function (c)
                    c:activate { context = 'mouse_click' }
                end
            ),
            awful.button(
                { mod_key },
                1,
                function (c)
                    c:activate { context = 'mouse_click', action = 'mouse_move'  }
                end
            ),
            awful.button(
                { mod_key },
                3,
                function (c)
                    c:activate { context = 'mouse_click', action = 'mouse_resize'}
                end
            ),
        })
    end
)
