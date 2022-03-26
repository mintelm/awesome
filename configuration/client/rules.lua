local awful = require('awful')
local ruled = require('ruled')
local gears = require('gears')
local beautiful = require('beautiful')

local shapes = require('modules.shapes')

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
                size_hints_honor = false,
                screen = awful.screen.focused,
                placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
            }
        }

        -- Add titlebars to normal clients and dialogs
        ruled.client.append_rule {
            id         = 'titlebars',
            rule_any   = { type = { 'normal', 'dialog' } },
            properties = { titlebars_enabled = true      }
        }

        ruled.client.append_rule {
            id         = 'floating',
            rule_any   = {
                class = {
                    'Gpick',
                    'Arandr',
                    'Bitwarden',
                    'Galculator',
                }
            },
            properties = { floating = true }
        }
    end
)
