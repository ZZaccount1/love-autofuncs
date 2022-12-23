-- autofuncs
-- https://gitlab.com/zz_pf/love-autofunctions
-- MIT license

-- TODO: Calling the update,draw,keypressed etc. from this script, not from main.lua
-- TODO: Order system

local autofuncs = {}

function pushTable(table, place, value)
    local array = table

    for i=#array,place,-1 do
        array[i+1] = table[i]
    end
    
    array[place] = value

    return array
end

function getSubFiles(folder, filesTable)
    if folder == "" then return {} end
	local files = love.filesystem.getDirectoryItems(folder)
	for i,v in ipairs(files) do
		local file = folder.."/"..v
		local info = love.filesystem.getInfo(file)
		if info then
			if info.type == "file" then
                table.insert(filesTable, file)
			elseif info.type == "directory" then
                filesTable = getSubFiles(file, filesTable)
			end
		end
	end
	return filesTable
end

function autofuncs.load(autofuncs, path)
    scriptsPath = path

    files = getSubFiles(scriptsPath, {})
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

    -- Load everything
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].load then
            scriptsInstances[i].load()
        end
    end
end

function autofuncs.update(autofuncs, dt)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].update then
            scriptsInstances[i].update(dt)
        end
    end
end

function autofuncs.draw(autofuncs)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].draw then
            scriptsInstances[i].draw()
        end
    end
end

function autofuncs.keypressed(autofuncs, k, sc, r)
    for i in ipairs(scriptsInstances) do
        if scriptsInstances[i].keypressed then
            scriptsInstances[i].keypressed(k , sc, r)
        end
    end
end

return
{
    load = function(...) return autofuncs.load(autofuncs, ...) end,
    update = function(...) return autofuncs.update(autofuncs, ...) end,
    draw = function(...) return autofuncs.draw(autofuncs, ...) end,
    keypressed = function(...) return autofuncs.keypressed(autofuncs, ...) end,
}