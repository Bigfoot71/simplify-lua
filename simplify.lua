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

local simplifyRadialDistance = function(points, sqTolerance)

    local prev, point = points[1]
    local new_points = {prev}

    for i = 1, #points do

        point = points[i]

        if getDist(point, prev) > sqTolerance then
            new_points[#new_points+1] = point
            prev = point
        end

    end

    if prev[1] ~= point[1] and prev[2] ~= point[2] then
        new_points[#new_points+1] = point
    end

    return new_points

end

local simplifyDPStep
simplifyDPStep = function(points, first, last, sqTolerance, simplified)

    local maxDist, index = sqTolerance

    for i = first+1, last do

        local dist = getSegDist(
            points[i], points[first], points[last]
        )

        if (dist > maxDist) then
            index, maxDist = i, dist
        end

    end

    if maxDist > sqTolerance then

        if index - first > 1 then
            simplifyDPStep(points, first, index, sqTolerance, simplified)
            simplified[#simplified+1] = points[index]
        end

        if last - index > 1 then
            simplifyDPStep(points, index, last, sqTolerance, simplified)
        end

    end

end

local simplifyDouglasPeucker = function(points, sqTolerance)

    local last = #points
    local simplified = {points[1]}

    simplifyDPStep(points, 1, last, sqTolerance, simplified)
    simplified[#simplified+1] = points[last]

    return simplified;

end

local function simplify(points, tolerance, highestQuality)

    tolerance = tolerance or .1
    highestQuality = highestQuality or true

    sqtolerance = tolerance ^ 2

    if not highestQuality then
        points = simplifyRadialDistance(points, sqtolerance)
    end

    points = simplifyDouglasPeucker(points, sqtolerance)

    return points

end

return simplify
