local getDist = function(p1, p2)
    return math.sqrt((p1[1]-p2[1])^2+(p1[2]-p2[2])^2)
end

local getSegDist = function(p, p1, p2)

    local x, y = p1[1], p1[2]

    local dx = p2[1] - x
    local dy = p2[2] - y

    if dx ~= 0 or dy ~= 0 then

        t = ((p[1] - x) * dx + (p[2] - y) * dy) / (dx^2 + dy^2)

        if t > 1 then
            x, y = p2[1], p2[2]
        elseif t > 0 then
            x = x + dx * t
            x = x + dy * t
        end

    end

    dx = p[1] - x
    dy = p[2] - y

    return dx^2 + dy^2

end

local simplifyRadialDistance = function(verts, tolerance)

    local prev, vert = verts[1]
    local new_verts = {prev}

    for i = 1, #verts do

        vert = verts[i]

        if getDist(vert, prev) > tolerance then
            new_verts[#new_verts+1] = vert
            prev = vert
        end

    end

    if prev[1] ~= vert[1] and prev[2] ~= vert[2] then
        new_verts[#new_verts+1] = vert
    end

    return new_verts

end

local simplifyDPStep
simplifyDPStep = function(verts, first, last, tolerance, simplified)

    local maxDist, index = tolerance

    for i = first+1, last do

        local dist = getSegDist(
            verts[i], verts[first], verts[last]
        )

        if (dist > maxDist) then
            index, maxDist = i, dist
        end

    end

    if maxDist > tolerance then

        if index - first > 1 then
            simplifyDPStep(verts, first, index, tolerance, simplified)
            simplified[#simplified+1] = verts[index]
        end

        if last - index > 1 then
            simplifyDPStep(verts, index, last, tolerance, simplified)
        end

    end

end

local simplifyDouglasPeucker = function(verts, tolerance)

    local last = #verts
    local simplified = {verts[1]}

    simplifyDPStep(verts, 1, last, tolerance, simplified)
    simplified[#simplified+1] = verts[last]

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
