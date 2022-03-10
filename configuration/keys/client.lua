local awful = require('awful')

local modkey = require('configuration.keys.mod').mod_key
local altkey = require('configuration.keys.mod').alt_key
local alt_tab = require('module.alt_tab')

client.connect_signal(
    'request::default_keybindings',
    function()
        awful.keyboard.append_client_keybindings({
            -- group = client
            awful.key(
                { modkey },
                'w',
                function(c)
                    c:kill()
                end,
                { description = 'close', group = 'client' }
            ),
            awful.key(
                { modkey },
                'f',
                function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = 'toggle fullscreen', group = 'client' }
            ),
            awful.key(
                { modkey },
                'm',
                function(c)
                    c.maximized = not c.maximized
                end,
                { description = 'toggle fullscreen', group = 'client' }
            ),
            awful.key(
                { altkey },
                'Tab',
                function ()
                    alt_tab.switch( 1, altkey, 'Alt_L', 'Shift', 'Tab')
                end,
                { description = 'cycle client list forwards', group = 'client' }
            ),
                awful.key(
                { altkey, 'Shift' },
                'Tab',
                function ()
                    alt_tab.switch(-1, altkey, 'Alt_L', 'Shift', 'Tab')
                end,
                { description = 'cycle client list backwards', group = 'client' }
            ),
            -- group = screen
            awful.key(
                { modkey, 'Shift' },
                ',',
                function(c)
                    c:move_to_screen()
                end,
                { description = 'move client to next screen', group = 'screen' }
            ),
            awful.key(
                { modkey, 'Shift' },
                '.',
                function(c)
                    c:move_to_screen(c.screen.index-1)
                end,
                { description = 'move client to previous screen', group = 'screen' }
            )
        })
    end
)
