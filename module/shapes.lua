local gears = require('gears')

local shapes = {}

function shapes.prrect(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

function shapes.powerline(width, height, depth)
    return function(cr)
        gears.shape.powerline(cr, width, height, depth)
    end
end

function shapes.hexagon(width, height)
    return function(cr)
        gears.shape.hexagon(cr, width, height)
    end
end

function shapes.circle(width, height)
    return function(cr)
        gears.shape.rounded_bar(cr, width, height)
    end
end

return shapes
