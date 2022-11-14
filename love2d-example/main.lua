local simplify = require("simplify-(simple-table)")


local polyline, len = {25,50, 25,50}, 2
local tolerance, highestQuality = .1, false


function love.load()

    Font = love.graphics.getFont()
    Win_w, Win_h = love.graphics.getDimensions()
    KeyTimer = 0

end


function love.update(dt)

    local mx, my = love.mouse.getPosition()

    polyline[len+1] = mx
    polyline[len+2] = my

    -- Polyline commands --

    if love.mouse.isDown(1) then
        len = len + 2

    elseif love.mouse.isDown(2) then

        polyline = simplify(
            polyline,
            tolerance,
            highestQuality
        )

        len = #polyline-2

    end

    -- Simplify parameters commands --

    if KeyTimer == 0 and love.keyboard.isDown("left") then
        tolerance, KeyTimer = tolerance - .01, .075
    elseif KeyTimer == 0 and love.keyboard.isDown("right") then
        tolerance, KeyTimer = tolerance + .01, .075
    end

    -- Update KeyTimer --

    if KeyTimer > 0 then
        KeyTimer = KeyTimer - dt
    elseif KeyTimer < 0 then
        KeyTimer = 0
    end

end

function love.keypressed(key)
    if key == "space" then
        highestQuality = not highestQuality
    elseif key == "r" then
        polyline, len = {25,50, 25,50}, 2
    end
end


function love.draw()

    -- Draw polyline (one by one to avoid the visual effects of love2d) --

    for i = 1, #polyline-3, 2 do
        love.graphics.line(
            polyline[i], polyline[i+1],
            polyline[i+2], polyline[i+3]
        )
    end

    -- Draw points --

    love.graphics.setColor(1,1,0)
    for i = 1, #polyline-1, 2 do
        love.graphics.circle("fill",
            polyline[i], polyline[i+1], 2
        )
    end

    -- Print points number --

    love.graphics.setColor(1,1,1)
    love.graphics.print(
        "Points number: "..tostring(#polyline/2), 0, 0
    )

    -- Print command infos --

    love.graphics.print(
        "Left click to add point.", 0, Win_h-32
    )
    love.graphics.print(
        "Right click to apply simplify function.", 0, Win_h-16
    )

    local str = "Press R to reset"
    local w = Font:getWidth(str)

    love.graphics.print(str, Win_w-w, 0)

    str = "LEFT and RIGHT to change 'tolerance': "..tostring(tolerance)
    w = Font:getWidth(str)

    love.graphics.print(str, Win_w-w, Win_h-32)

    str = "SPACE to change 'highestQuality' parameter: "..tostring(highestQuality)
    w = Font:getWidth(str)

    love.graphics.print(str, Win_w-w, Win_h-16)

end
