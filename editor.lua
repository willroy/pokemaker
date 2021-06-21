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

back = love.graphics.newImage("assets/background.png")

local scale = 1
local yMovement = 0
local xMovement = 0

local currentSpriteSheet = spriteSheets["groundtiles"]
local spriteSheetScroll = 0

local function screenMovement()
    if love.keyboard.isDown("w") then yMovement = yMovement + 32 end
    if love.keyboard.isDown("a") then xMovement = xMovement + 32 end
    if love.keyboard.isDown("s") then yMovement = yMovement - 32 end
    if love.keyboard.isDown("d") then xMovement = xMovement - 32 end
end

function editor.load() 
  	love.window.setTitle("Pokemaker - Editor - "..love.filesystem.getWorkingDirectory().."/projects/"..loadedFile)
end

function editor.update(dt)
	screenMovement()
end

function editor.draw()
	love.graphics.draw(back, -96, -96)

	if loadedDragTiles ~= nil then 
		for i=1,#loadedDragTiles do
		    if loadedDragTiles[i] ~= nil then
				local img = spriteSheets[loadedDragTiles[i][5]]
				local quad = love.graphics.newQuad(loadedDragTiles[i][3], loadedDragTiles[i][4], 32, 32, img)
				love.graphics.draw(img, quad, (xMovement+loadedDragTiles[i][1])*scale, (yMovement+loadedDragTiles[i][2])*scale, 0, scale, scale) 
		    end
		end
	end
    
    love.graphics.draw(currentSpriteSheet, 10, 10+spriteSheetScroll)
end

function editor.mousepressed(x, y, button, istouch) 
    --spritesheet interaction
    if x < 255 then
        
    end
end

function editor.keypressed(key, code) 
	if key == "escape" then scene = "home" end
	if key == "r" then 
		yMovement = 0 
		xMovement = 0 
	end
end

function editor.wheelmoved(x, y)
    if love.mouse.getX() > 255 then
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
