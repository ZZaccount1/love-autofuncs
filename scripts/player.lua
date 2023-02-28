player = {}

player.x = 0
player.y = 0
player.speed = 1

local rectangleSize = 10

function player:update(dt)
    print("dt1", dt)

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        player.y = player.y - player.speed
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        player.y = player.y + player.speed
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.x = player.x - player.speed    
    end
end

function player:draw()
    love.graphics.rectangle("fill", player.x, player.y, rectangleSize, rectangleSize)
end

return
{
    update = function(...) return player:update(...) end,
    draw = function(...) return player:draw(...) end,
}