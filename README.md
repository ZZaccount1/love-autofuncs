# Autofuncs
A small Lua module for [Love2D] that calls functions like [love.load], [love.update], [love.draw] etc. that are outside main.lua, without needing to require and call the functions by hand for each script.

[Love2D]: http://love2d.org/
[love.load]: https://love2d.org/wiki/love.load
[love.update]: https://love2d.org/wiki/love.update
[love.draw]: https://love2d.org/wiki/love.draw
[love.keypressed]: https://love2d.org/wiki/love.keypressed

## Compatibility
Love 11.0+
Currently compatible with Love 12

# Usage
The [autofuncs.lua](lib/autofuncs.lua) should be added in an existing project and required.
```lua
af = require("autofuncs")
```
Then after requiring it, you should load the module using the load function from the module itself. Also that load function requires the path to the folder where are all scripts, which the module will use later. For example, in this case the module will use all scripts from the folder "scripts".
```lua
af.load("scripts")
```
Every script from the specified folder earlier, needs to return at the end every function used.
```lua
--!  file: player.lua

player = {}

function player:update(dt)
    -- your code
end

function player:draw()
    -- your code
end

return
{
    update = function(...) return player.update(player, ...) end,
    draw = function(...) return player.draw(player, ...) end
}
```

# ToDo
- [x] All in one function
- [x] Order system
- [x] Move library outside the lib folder
- [x] Gitignore
- [ ] Check compatibility with different love versions 
- [ ] Support for other love.callbacks 
- [ ] Better readme
- [ ] Error printing

# License
This library is a free software. You can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
