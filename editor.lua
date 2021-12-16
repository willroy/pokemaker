local function roundDown(n)
  for i=0,32 do
    if n % 32 == 0 then return n end
    n = n - 1
  end
end

local editor = {}

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

local spriteSheets = {["vegetation"] = vegetation, ["groundtiles"] = groundtiles, ["rocks"] = rocks, ["items"] = items, ["othero"] = othero, ["buildings"] = buildings, ["walls"] = walls, ["flooring"] = flooring, ["stairs"] = stairs, ["misc"] = misc, ["electronics"] = electronics, ["tables"] = tables, ["otheri"] = otheri}

local back = love.graphics.newImage("assets/background.png")
local grid = love.graphics.newImage("assets/grid.png")
local buttonsSheet = love.graphics.newImage("assets/editorbuttons.png")
buttons = {{love.graphics.newQuad(0, 0, 32, 32, buttonsSheet:getDimensions()), love.graphics.newQuad(0, 0, 152, 32, buttonsSheet:getDimensions())}, 
		   {love.graphics.newQuad(0, 32, 32, 32, buttonsSheet:getDimensions()), love.graphics.newQuad(0, 32, 152, 32, buttonsSheet:getDimensions())}}

local scale = 1
local yMovement = 0
local xMovement = 0

local currentSpriteSheet = "groundtiles"
local spriteSheetScroll = 0
local selectedTile

local mouseX = 0
local mouseY = 0

local addingCollision = false

local function screenMovement()
    if love.keyboard.isDown("w") then yMovement = yMovement + 32 end
    if love.keyboard.isDown("a") then xMovement = xMovement + 32 end
    if love.keyboard.isDown("s") then yMovement = yMovement - 32 end
    if love.keyboard.isDown("d") then xMovement = xMovement - 32 end
end

function editor.load() 
  	love.window.setTitle("Pokemaker - Editor - "..love.filesystem.getWorkingDirectory().."/projects/"..loadedFileTiles)
end

function editor.update(dt)
	x, y = love.mouse.getPosition()
	if addingCollision == false then
		if love.mouse.isDown(1) and roundDown(x) > 255 and y > 64 then
			loadedDragTiles[#loadedDragTiles+1] = {roundDown(x-xMovement), roundDown(y-yMovement), selectedTile[1], selectedTile[2], selectedTile[3]}
		end
		if love.mouse.isDown(2) then
			for i=1,#loadedDragTiles do
				if loadedDragTiles[i] ~= nil then
					if loadedDragTiles[i][1] == roundDown(x-xMovement) and loadedDragTiles[i][2] == roundDown(y-yMovement) then
					  	table.remove(loadedDragTiles, i)
					end
				end
			end
		end
	end
	screenMovement()
end

function editor.draw()

	love.graphics.draw(grid, 0, 0)
	love.graphics.setColor(1, 1, 1, 1)
	if loadedDragTiles ~= nil then 
		for i=1,#loadedDragTiles do
		    if loadedDragTiles[i] ~= nil then
		    	if addingCollision == true then love.graphics.setColor(1, 1, 1, 0.5) end
				local img = spriteSheets[loadedDragTiles[i][5]]
				local quad = love.graphics.newQuad(loadedDragTiles[i][3], loadedDragTiles[i][4], 32, 32, img)
				love.graphics.draw(img, quad, ((xMovement+loadedDragTiles[i][1])*scale)+mouseX, ((yMovement+loadedDragTiles[i][2])*scale)+mouseY, 0, scale, scale) 
		    end
		end
	end
    
    if selectedTile ~= nil then
        local img = spriteSheets[selectedTile[3]]
        local quad = love.graphics.newQuad(selectedTile[1], selectedTile[2], 32, 32, img)
        love.graphics.draw(img, quad, 1236, 936, 0, 2, 2) 
    end
    
    love.graphics.draw(back, 0, 0)
    love.graphics.draw(spriteSheets[currentSpriteSheet], 2, 2+spriteSheetScroll)
	love.graphics.draw(buttonsSheet, buttons[1][1], 266, 8)
	love.graphics.draw(buttonsSheet, buttons[2][1], 304, 8)

end

function editor.mousepressed(x, y, button, istouch) 
    if roundDown(x) < 255 then
        selectedTile = {roundDown(x), roundDown(y-spriteSheetScroll), currentSpriteSheet}
    end
    if roundDown(x) > 255 and y < 100 then
    	if y < 100 then
    		
    	end
    end
end

function editor.keypressed(key, code) 
	if key == "escape" then scene = "home" end
	if key == "r" then 
		yMovement = 0 
		xMovement = 0 
	end
	if key == "x" then
		stream = io.open(love.filesystem.getWorkingDirectory().."/projects/"..loadedFileTiles, "w")
		for i=1,#loadedDragTiles do
	        if loadedDragTiles[i] == nil then 
	        else
	          stream:write(loadedDragTiles[i][1], " ") 
	          stream:write(loadedDragTiles[i][2], " ") 
	          stream:write(loadedDragTiles[i][3], " ") 
	          stream:write(loadedDragTiles[i][4], " ") 
	          stream:write(loadedDragTiles[i][5], "\n") 
	        end
      	end
      	stream.close()
      	-- SAVIGN FOR COLLISION MAPPER
  --     	stream = io.open(love.filesystem.getWorkingDirectory().."/projects/"..loadedFileColli, "w")
		-- for i=1,#loadedDragTiles do
	 --        if loadedDragTiles[i] == nil then 
	 --        else
	 --          stream:write(loadedDragTiles[i][1], " ") 
	 --          stream:write(loadedDragTiles[i][2], " ") 
	 --          stream:write(loadedDragTiles[i][3], " ") 
	 --          stream:write(loadedDragTiles[i][4], " ") 
	 --          stream:write(loadedDragTiles[i][5], "\n") 
	 --        end
  --     	end
  --     	stream.close()
	end
	if key == "c" then
		print(addingCollision)
		if addingCollision == false then addingCollision = true 
		else addingCollision = false end
	end
end

function editor.wheelmoved(x, y)
    if love.mouse.getX() > 255 then
        mouseX, mouseY = love.mouse.getPosition()
        if y > 0 then
            if scale == 2 then scale = 4 end
            if scale == 1 then scale = 2 end
            if scale == 0.5 then scale = 1 end
            if scale == 0.25 then scale = 0.5 end
        end
        if y < 0 then
            if scale == 0.5 then scale = 0.25 end
            if scale == 1 then scale = 0.5 end
            if scale == 2 then scale = 1 end
            if scale == 4 then scale = 2 end
        end
    else
        if y > 0 then
            spriteSheetScroll = spriteSheetScroll + 32
        end
        if y < 0 then
            spriteSheetScroll = spriteSheetScroll - 32
        end
    end
end

return editor
