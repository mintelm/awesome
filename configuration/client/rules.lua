local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal(
    'request::rules',
    function()
        -- All clients will match this rule
        ruled.client.append_rule {
            id = 'global',
            rule = { },
            properties = {
                focus = awful.client.focus.filter,
                raise = true,
                screen = awful.screen.focused,
                placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
            }
        }

        -- Add titlebars to normal clients and dialogs
        ruled.client.append_rule {
            id         = 'titlebars',
            rule_any   = { type = { 'normal', 'dialog' } },
            properties = { titlebars_enabled = true      }
        }
    end
)
