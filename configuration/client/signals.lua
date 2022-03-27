local titlebar = require('modules.titlebar')

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
