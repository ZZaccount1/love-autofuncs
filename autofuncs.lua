-- autofuncs
-- https://github.com/ZZaccount1/love-autofuncs
-- MIT license

local autofuncs = {}
local hook = {}

local function updateAll(...)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].update then
            scriptsInstances[i].update(...)
        end
    end
end

local function drawAll()
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].draw then
            scriptsInstances[i].draw()
        end
    end
end

local function keypressedAll(...)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].keypressed then
            scriptsInstances[i].keypressed(...)
        end
    end
end

local function mousepressedAll(...)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].mousepressed then
            scriptsInstances[i].mousepressed(...)
        end
    end
end

local function load(path)
    scriptsPath = path
    
    files = autofuncs.getSubFiles(scriptsPath, {})
    scripts = {}
    scriptsInstances = {}
    
    -- Next loop will select from all the files only the ones that have the .lua extension
    for i in ipairs(files) do
        ext = files[i]:match("^.+%.(.+)$")
        if ext == "lua" then
            table.insert( scripts, files[i])
        end
    end
    
    -- Converting the path to the require path (eg path/to/file.lua -> path.to.file),
    -- and then requiring it
    for i in ipairs(scripts) do
        local val = scripts[i]:match("(.+)%..+$")
        val = string.gsub(val, "/",".")
        
        reqRes = require(val)
        
        if reqRes ~= true and reqRes ~= nil then
            table.insert(scriptsInstances, require(val))
        end
    end
    
    -- Ordering
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].order then
            local t = scriptsInstances
            local to = scriptsInstances[i].order
            local from = i
            
            if to > #scriptsInstances then
                to = #scriptsInstances
            end

            table.insert(t, to, table.remove(t, from))
        end
    end

    -- Load
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].load then
            scriptsInstances[i].load()
        end
    end
    
    -- Update
    hook.update = love.update
    love.update = function(...)
        if hook.update then
            hook.update(...) 
        end
        updateAll(...)
    end

    -- Draw
    hook.draw = love.draw
    love.draw = function(...)
        if hook.draw then
            hook.draw(...)
        end
        drawAll(...)
    end

    -- Keypressed
    hook.keypressed = love.keypressed
    love.keypressed = function(...)
        if hook.keypressed then
            hook.keypressed(...)
        end
        keypressedAll(...)
    end

    -- Mousepressed
    hook.mousepressed = love.mousepressed
    love.mousepressed = function(...)
        if hook.mousepressed then
            hook.mousepressed(...)
        end
        mousepressedAll(...)
    end
end

function autofuncs.getSubFiles(folder, filesTable)
    if folder == "" then return {} end
	local files = love.filesystem.getDirectoryItems(folder)
	for i,v in ipairs(files) do
		local file = folder.."/"..v
		local info = love.filesystem.getInfo(file)
		if info then
			if info.type == "file" then
                table.insert(filesTable, file)
			elseif info.type == "directory" then
                filesTable = autofuncs.getSubFiles(file, filesTable)
			end
		end
	end
	return filesTable
end

local function update(...)
    love.update = hook.update
    updateAll()
end

local function draw(...)
    love.draw = hook.draw
    drawAll()
end

local function keypressed(...)
    love.keypressed = hook.keypressed
    keypressedAll()
end

local function mousepressed(...)
    love.mousepressed = hook.mousepressed
    mousepressedAll()
end

return
{
    load = function(...) return load(...) end,
    update = function(...) return update(...) end,
    draw = function(...) return draw(...) end,
    keypressed = function(...) return keypressed(...) end,
    mousepressed = function(...) return mousepressed(...) end
}
