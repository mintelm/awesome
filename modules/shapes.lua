local gears = require('gears')

local shapes = {}

function shapes.rrect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

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

function shapes.circle(size)
    return function(cr)
        gears.shape.rounded_bar(cr, size, size)
    end
end

function shapes.square(size)
    return function(cr)
        gears.shape.partially_rounded_rect(cr, size, size, _, _, _, _, 0)
    end
end

return shapes
