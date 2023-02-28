function love.load()
    af = require("autofuncs")
    af.load("scripts")
end

function love.update(dt)
    player:update(dt)
end

function love.keypressed(k, sc, r)
    if k == "escape" then
        love.event.quit()
    end
end