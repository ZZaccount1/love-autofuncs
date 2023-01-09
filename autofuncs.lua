-- autofuncs
-- https://github.com/ZZaccount1/love-autofuncs
-- MIT license

local autofuncs = {}

local function update(...)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].update then
            scriptsInstances[i].update(...)
        end
    end
end

local function draw()
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].draw then
            scriptsInstances[i].draw()
        end
    end
end

local function keypressed(...)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].keypressed then
            scriptsInstances[i].keypressed(...)
        end
    end
end

function autofuncs:load(path)
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
        table.insert(scriptsInstances, require(val))
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

    local hook = {}
    
    -- Update
    hook.update = love.update
    love.update = function(...)
        if hook.update then
            hook.update(...) 
        end
        update(...)
    end

    -- Draw
    hook.draw = love.draw
    love.draw = function(...)
        if hook.draw then
            hook.draw(...)
        end
        draw(...)
    end

    -- Keypressed
    hook.keypressed = love.keypressed
    love.keypressed = function(...)
        if hook.keypressed then
            hook.keypressed(...)
        end
        keypressed(...)
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

return
{
    load = function(...) return autofuncs:load(...) end
}
