function love.load()
    af = require("lib.autofuncs")
    af.load("scripts")
end

function love.keypressed(k, sc, r)
    if k == "escape" then
        love.event.quit()
    end
end