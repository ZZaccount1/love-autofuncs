function love.load()
    af = require("autofuncs")
    af.load("scripts")
end

function love.keypressed(k, sc, r)
    if k == "escape" then
        love.event.quit()
    end
end