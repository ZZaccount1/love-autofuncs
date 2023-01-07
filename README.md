# Autofuncs
### About
A small Lua module for [Love2D] that calls functions like [love.load], [love.update], [love.draw] etc. that are outside main.lua, without needing to require and call the functions by hand for each script.

[Love2D]: http://love2d.org/
[love.load]: https://love2d.org/wiki/love.load
[love.update]: https://love2d.org/wiki/love.update
[love.draw]: https://love2d.org/wiki/love.draw
[love.keypressed]: https://love2d.org/wiki/love.keypressed

### Compatibility
Love 11.0+
<br>Currently compatible with Love 12

### Supported functions
[love.load], [love.update], [love.draw], [love.keypressed].

# Usage
### Require
The [autofuncs.lua](autofuncs.lua) should be added in an existing project and required.
```lua
af = require("autofuncs")
```
### Load
Then after requiring it, you should load the module using the load function from the module itself. Also that load function requires the path to the folder where are all scripts, which the module will use later. For example, in this case the module will use all scripts from the folder "scripts".
```lua
af.load("scripts")
```
### Script
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
### Order system
If you need to call an script before or after the other one you can use the order system.
<br>To use that you need to return at the end of the script, along with functions the order value.
```lua
return
{
    -- your code
    order = 1
}
```

# ToDo
- [x] All in one function
- [x] Order system
- [x] Move library outside the lib folder
- [x] Gitignore
- [x] Check compatibility with different love versions 
- [x] Better readme
- [ ] Support for other love.callbacks 
- [ ] Error printing

# License
This library is a free software. You can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
