require('awful.autofocus')

local awful = require('awful')
local beautiful = require('beautiful')

local titlebar = require('modules.titlebar')
local modkey = require('configuration.keys.mod').mod_key

client.connect_signal(
    'request::titlebars',
    function(c)
        titlebar.set_decoration(c)
    end
)

client.connect_signal(
    'tagged',
    function(c)
        titlebar.dynamic_titlebar(c)
        -- let awesome do the rescaling if maximized clients are tagged
        if c.maximized then
            c.maximized = not c.maximized
            c.maximized = not c.maximized
        end
    end
)

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
                { modkey },
                1,
                function (c)
                    c:activate { context = 'mouse_click', action = 'mouse_move'  }
                end
            ),
            awful.button(
                { modkey },
                3,
                function (c)
                    c:activate { context = 'mouse_click', action = 'mouse_resize'}
                end
            ),
        })
    end
)
