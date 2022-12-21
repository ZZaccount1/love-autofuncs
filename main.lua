function love.load()
    af = require("lib.autofuncs")
    af.load("scripts")
end

function love.update(dt)
    af.update(dt)
end

function love.draw()
    af.draw()
end

function love.keypressed(k, sc, r)
    af.keypressed(k,sc,r)

    if k == "escape" then
        love.event.quit()
    end
end