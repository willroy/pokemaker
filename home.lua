local function splitString(inpstr) 
    local list = {}
    for str in string.gmatch(inpstr, "%S+") do
        table.insert(list, str)
    end
    return list
end

local function dirLookup(dir)
	projects = {}      
	for file in io.popen([[dir "]]..dir..[[" /b]]):lines() do
        if (#splitString(file) > 0) then
            for i = 1, #splitString(file), 1 do
               projects[#projects+1] = splitString(file)[i] 
            end
        else
            projects[#projects+1] = file
        end
	end
    projectsSantised = {}
    for i=1,#projects do
       if ( string.sub(projects[i], -5) == ".proj" ) then
            projectsSantised[#projectsSantised+1] = projects[i]
       end
    end
	return projects
end

local function previewMask()
   love.graphics.rectangle("fill", 455, 282, 793, 666)
end

local home = {}

local background = love.graphics.newImage("assets/backgroundmenu.png")
local buttons = love.graphics.newImage("assets/buttons.png")
local newFileNotPressed = love.graphics.newQuad(0, 0, 134, 31, buttons:getDimensions())
local newFilePressed = love.graphics.newQuad(134, 0, 134, 31, buttons:getDimensions())
local FileNotPressed = love.graphics.newQuad(0, 31, 134, 31, buttons:getDimensions())
local FilePressed = love.graphics.newQuad(134, 31, 134, 31, buttons:getDimensions())

local vegetation = love.graphics.newImage("assets/outside/vegetation.png")
local groundtiles = love.graphics.newImage("assets/outside/groundTiles.png")
local rocks = love.graphics.newImage("assets/outside/rocks.png")
local items = love.graphics.newImage("assets/outside/items.png")
local othero = love.graphics.newImage("assets/outside/other.png")
local buildings = love.graphics.newImage("assets/outside/buildings.png")
local walls = love.graphics.newImage("assets/interiorgeneral/walls.png")
local flooring = love.graphics.newImage("assets/interiorgeneral/flooring.png")
local stairs = love.graphics.newImage("assets/interiorgeneral/stairs.png")
local misc = love.graphics.newImage("assets/interiorgeneral/misc.png")
local electronics = love.graphics.newImage("assets/interiorgeneral/electronics.png")
local tables = love.graphics.newImage("assets/interiorgeneral/tables.png")
local otheri = love.graphics.newImage("assets/interiorgeneral/other.png")
local video = love.graphics.newVideo("assets/prank.ogv")

local spriteSheets = {["vegetation"] = vegetation, ["groundtiles"] = groundtiles, ["rocks"] = rocks, ["items"] = items, ["othero"] = othero, ["buildings"] = buildings, ["walls"] = walls, ["flooring"] = flooring, ["stairs"] = stairs, ["misc"] = misc, ["electronics"] = electronics, ["tables"] = tables, ["otheri"] = otheri}

local projects = dirLookup(love.filesystem.getWorkingDirectory().."/projects/")

local dragTiles
local displayNum = 0

love.audio.setVolume(0.1)

function home.update(dt)
end

function home.draw() 
  love.graphics.setColor(1, 1, 1)

	love.graphics.draw(background, 0, 0)
	x, y = love.mouse.getPosition()
	if x > 44 and x < 178 and y > 180 and y < 211 then love.graphics.draw(buttons, newFilePressed, 44, 180) 
	else love.graphics.draw(buttons, newFileNotPressed, 44, 180) end
    
    local count = 0
    local hasHover = false
    local tmpHover = 0


    if #projects > 0 then
	    for i=1,#projects do
	    	if x > 75 and x < 210 and y > 292+(31*count) and y < 323+(31*count) then
	    		hasHover = true
	    		tmpHover = count+1
	    		love.graphics.draw(buttons, FilePressed, 75, 290+(31*count))
	    		love.graphics.setColor(0, 0, 0)
		    	love.graphics.print(projects[i], 75, 302+(31*count))
		    	if displayNum == 0 then
		    		displayNum = count+1
		    		local tmp = {}
				    for line in io.lines(love.filesystem.getWorkingDirectory().."/projects/"..projects[count+1].."/"..projects[count+1].."Tiles.proj") do
				    	item = {}
						for substring in line:gmatch("%S+") do
							table.insert(item, substring)
						end
						tmp[#tmp+1] = {tonumber(item[1]), tonumber(item[2]), tonumber(item[3]), tonumber(item[4]), item[5]}
				    end
				    dragTiles = tmp
		    	end
			  else 
          love.graphics.draw(buttons, FileNotPressed, 75, 290+(31*count))
          love.graphics.setColor(0, 0, 0)
          love.graphics.print(projects[i], 75, 300+(31*count))
        end
	    	
		    love.graphics.setColor(1, 1, 1)
		    count = count + 1
	    end
	end

	if tmpHover ~= displayNum then displayNum = 0 end
	if hasHover == false then displayNum = 0 end

	love.graphics.stencil(previewMask, "replace", 1)
	love.graphics.setStencilTest("greater", 0)

	if hasHover and dragTiles ~= nil then 
		for i=1,#dragTiles do
		    if dragTiles[i] ~= nil then
				img = spriteSheets[dragTiles[i][5]]
				quad = love.graphics.newQuad(dragTiles[i][3], dragTiles[i][4], 32, 32, img)
				love.graphics.draw(img, quad, 455+dragTiles[i][1], 288+dragTiles[i][2]) 
		    end
		end
	end

	love.graphics.setStencilTest()
end

function home.mousepressed(x, y, button, istouch) 
	if displayNum ~= 0 then
		print(projects[displayNum])
		local stringsplit = {}
		for i in projects[displayNum]:gsub("%f[.]%.%f[^.]", "\0"):gmatch"%Z+" do
			stringsplit[#stringsplit+1] = i
		end
		local name = stringsplit[1]
		loadedFileTiles = name.."/"..name.."Tiles"..".proj"
		loadedFileColli = name.."/"..name.."Colli"..".proj"
		loadedDragTiles = dragTiles
		editor.load() 
		scene = "editor"
	end
	if x > 1161 and x < 1258 and y > 51 and y < 135 then
		video:play()
	end
end

function home.keypressed(key, code) 
	if key == "escape" then love.event.quit() end
end

return home
