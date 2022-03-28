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

function shapes.powerline(depth)
    return function(cr, width, height)
        gears.shape.powerline(cr, width, height, depth)
    end
end

function shapes.hexagon()
    return function(cr, width, height)
        gears.shape.hexagon(cr, width, height)
    end
end

function shapes.circle()
    return function(cr, width, height)
        gears.shape.rounded_bar(cr, width, height)
    end
end

function shapes.square()
    return function(cr, width, height, _, _, _, _)
        gears.shape.partially_rounded_rect(cr, width, height, _, _, _, _, 0)
    end
end

return shapes
