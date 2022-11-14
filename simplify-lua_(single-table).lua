local getDist function(x1,y1,x2,y2)
    return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

local getSegDist = function(x,y, x1,y1, x2,y2)

    local dx = x2 - x1
    local dy = y2 - y1

    if dx ~= 0 or dy ~= 0 then

        t = ((x - x1) * dx + (y - y1) * dy) / (dx^2 + dy^2)

        if t > 1 then
            x1, y1 = x2, y2
        elseif t > 0 then
            x1 = x1 + dx * t
            y1 = y1 + dy * t
        end

    end

    dx = x - x1
    dy = y - y1

    return dx^2 + dy^2

end

local simplifyRadialDistance = function(verts, tolerance)

    local prev_x, x = verts[1]
    local prev_y, y = verts[2]

    local new_verts = {prev_x, prev_y}

    for i = 1, #verts-1, 2 do

        x, y = verts[i], verts[i+1]

        if getDist(x,y, prev_x,prev_y) > tolerance then
            new_verts[#new_verts+1] = x
            new_verts[#new_verts+1] = y
            prev_x, prev_y = x, y
        end

    end

    if prev_x ~= x and prev_y ~= y then
        new_verts[#new_verts+1] = x
        new_verts[#new_verts+1] = y
    end

    return new_verts

end

local simplifyDPStep
simplifyDPStep = function(verts, first, last, tolerance, simplified)

    local maxDist, index = tolerance

    for i = first+2, last, 2 do

        local dist = getSegDist(
            verts[i], verts[i+1],
            verts[first], verts[first+1],
            verts[last], verts[last+1]
        )

        if (dist > maxDist) then
            index, maxDist = i, dist
        end

    end

    if maxDist > tolerance then

        if index - first > 1 then
            simplifyDPStep(verts, first, index, tolerance, simplified)
            simplified[#simplified+1] = verts[index]
            simplified[#simplified+1] = verts[index+1]
        end

        if last - index > 1 then
            simplifyDPStep(verts, index, last, tolerance, simplified)
        end

    end

end

local simplifyDouglasPeucker = function(verts, tolerance)

    local last = #verts-1
    local simplified = {verts[1], verts[2]}

    simplifyDPStep(verts, 1, last, tolerance, simplified)

    simplified[#simplified+1] = verts[last]
    simplified[#simplified+1] = verts[last+1]

    return simplified;

end

local function simplifyPoly(verts, tolerance, highestQuality)

    tolerance = tolerance or .1
    highestQuality = highestQuality or true

    sqtolerance = tolerance ^ 2

    if not highestQuality then
        verts = simplifyRadialDistance(verts, sqtolerance)
    end

    verts = simplifyDouglasPeucker(verts, sqtolerance)

    return verts

end

return simplifyPoly
