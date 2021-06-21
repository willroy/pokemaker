home = require("home")
editor = require("editor")

scene = "home"
loadedFile = nil
loadedDragTiles = nil

local icon = love.image.newImageData("assets/icon.png");

function love.load() 
  	love.window.setTitle("Pokemaker - Menu")
	love.window.setMode(1300, 1000)
  	love.graphics.setBackgroundColor(1,1,1)
  	love.window.setIcon(icon);
end

function love.update(dt)
	if scene == "home" then home.update(dt) end
	if scene == "editor" then editor.update(dt) end
end

function love.draw() 
	if scene == "home" then home.draw() end
	if scene == "editor" then editor.draw() end
end

function love.mousepressed(x, y, button, istouch)
	if scene == "home" then home.mousepressed(x, y, button, istouch) end
	if scene == "editor" then editor.mousepressed(x, y, button, istouch) end
end

function love.keypressed(key, code)
	if scene == "home" then home.keypressed(key, code) end
	if scene == "editor" then editor.keypressed(key, code) end
end

function love.wheelmoved(x, y)
	if scene == "home" then home.wheelmoved(x, y) end
	if scene == "editor" then editor.wheelmoved(x, y) end
end
