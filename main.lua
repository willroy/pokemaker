vegetation = love.graphics.newImage("assets/outside/vegetation.png")
groundtiles = love.graphics.newImage("assets/outside/groundTiles.png")
rocks = love.graphics.newImage("assets/outside/rocks.png")
items = love.graphics.newImage("assets/outside/items.png")
othero = love.graphics.newImage("assets/outside/other.png")
buildings = love.graphics.newImage("assets/outside/buildings.png")
walls = love.graphics.newImage("assets/interiorgeneral/walls.png")
flooring = love.graphics.newImage("assets/interiorgeneral/flooring.png")
stairs = love.graphics.newImage("assets/interiorgeneral/stairs.png")
misc = love.graphics.newImage("assets/interiorgeneral/misc.png")
electronics = love.graphics.newImage("assets/interiorgeneral/electronics.png")
tables = love.graphics.newImage("assets/interiorgeneral/tables.png")
otheri = love.graphics.newImage("assets/interiorgeneral/other.png")

loadsaveback = love.graphics.newImage("assets/saveload.png")
painttilebox = love.graphics.newImage("assets/painttile.png")

back = love.graphics.newImage("assets/background.png")
backx = -104
backy = -104

spriteSheets = {["vegetation"] = vegetation, ["groundtiles"] = groundtiles, ["rocks"] = rocks, ["items"] = items, ["othero"] = othero, ["buildings"] = buildings, ["walls"] = walls, ["flooring"] = flooring, ["stairs"] = stairs, ["misc"] = misc, ["electronics"] = electronics, ["tables"] = tables, ["otheri"] = otheri}

function getSheetString() 
  if displayedSheet == vegetation then return "vegetation" end
  if displayedSheet == groundtiles then return "groundtiles" end
  if displayedSheet == rocks then return "rocks" end
  if displayedSheet == items then return "items" end
  if displayedSheet == othero then return "othero" end
  if displayedSheet == buildings then return "buildings" end
  if displayedSheet == walls then return "walls" end
  if displayedSheet == flooring then return "flooring" end
  if displayedSheet == stairs then return "stairs" end
  if displayedSheet == misc then return "misc" end
  if displayedSheet == electronics then return "electronics" end
  if displayedSheet == tables then return "tables" end
  if displayedSheet == otheri then return "otheri" end
end

displayedSheet = vegetation
section = "outside"

dragTiles = {}
paintTile = {}
paintmode = false
layermode = "top"
dragging = 0
scroll = 0
shift = 0
saving = false
loading = false
saveinput = ""
loadinput = 1

function love.load()
  love.window.setMode(1300, 1000)
  love.graphics.setBackgroundColor(1,1,1)
  files = dirLookup("projects")
end

function roundDown(n)
  for i=0,32 do
    if n % 32 == 0 then return n end
    n = n - 1
  end
end

function love.update(dt)
  if saving or loading then
  else
    if love.mouse.isDown(1) then
      if paintmode and love.mouse.getX() < 260 then
        rx = roundDown(love.mouse.getX())
        ry = roundDown(love.mouse.getY())
        paintTile = {rx, ry-scroll, getSheetString()}
        paintmode = true
      elseif paintmode and love.mouse.getX() > 260  then
        rx = roundDown(love.mouse.getX())
        ry = roundDown(love.mouse.getY())
        if layermode == "top" then dragTiles[#dragTiles+1] = {rx, ry, paintTile[1], paintTile[2], paintTile[3], 1} end
        if layermode == "bot" then dragTiles[#dragTiles+1] = {rx, ry, paintTile[1], paintTile[2], paintTile[3], 0} end
        
        --dragTiles = sortByZIndex(dragTiles)
      else
        if dragging == 0 and paintmode == false and love.mouse.getX() < 260 then
          rx = roundDown(love.mouse.getX())
          ry = roundDown(love.mouse.getY())
          
          dragging = (rx/32)+((ry/32)*8)
          
          if layermode == "top" then dragTiles[#dragTiles+1] = {0, 0, rx, ry-scroll, getSheetString(), 1} end
          if layermode == "bot" then dragTiles[#dragTiles+1] = {0, 0, rx, ry-scroll, getSheetString(), 0} end
          for i=1,#dragTiles do
            for a=1,#dragTiles[i] do
              io.write(dragTiles[i][a].." ")
            end
            print("")
          end
          --dragTiles = sortByZIndex(dragTiles)
          for i=1,#dragTiles do
            for a=1,#dragTiles[i] do
              io.write(dragTiles[i][a].." ")
            end
            print("")
          end
        end 
      end
    else
      if dragging > 0 then
        if love.mouse.getX() < 260 then 
          dragging = 0
          table.remove(dragTiles, #dragTiles)
          return
        end
        lx = roundDown(love.mouse.getX())
        ly = roundDown(love.mouse.getY())
        dragTiles[#dragTiles][1] = lx
        dragTiles[#dragTiles][2] = ly
        dragging = 0
      end
    end
    
    if love.mouse.isDown(2) then
      rx = roundDown(love.mouse.getX())
      ry = roundDown(love.mouse.getY())
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        elseif dragTiles[i][1] == rx and dragTiles[i][2] == ry then
          table.remove(dragTiles, i)
        end
      end
    end
      
    if dragging > 0 then  
      dragTiles[#dragTiles][1] = love.mouse.getX()-16
      dragTiles[#dragTiles][2] = love.mouse.getY()-16
    end
    
    if love.keyboard.isDown("down") then
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        else dragTiles[i][2] = dragTiles[i][2] - 32 end
      end
    end
    if love.keyboard.isDown("right") then
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        else dragTiles[i][1] = dragTiles[i][1] - 32 end
      end
    end
    if love.keyboard.isDown("left") then
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        else dragTiles[i][1] = dragTiles[i][1] + 32 end
      end
    end
    if love.keyboard.isDown("up") then
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        else dragTiles[i][2] = dragTiles[i][2] + 32 end
      end
    end
  end
  if saving == true and love.keyboard.isDown("return") then
    stream = io.open("projects/"..saveinput..".proj", "w")
      for i=1,#dragTiles do
        if dragTiles[i] == nil then 
        else
          stream:write(dragTiles[i][1], " ") 
          stream:write(dragTiles[i][2], " ") 
          stream:write(dragTiles[i][3], " ") 
          stream:write(dragTiles[i][4], " ") 
          stream:write(dragTiles[i][5], "\n") 
        end
      end
      stream.close()
      saving = false
  elseif saving and love.keyboard.isDown("escape") then
    saving = false
    saveinput = ""
  end
  if loading and love.keyboard.isDown("return") then
    tmp = {}
    files = dirLookup("projects")
    for line in io.lines(files[loadinput]) do
      item = {}
      for substring in line:gmatch("%S+") do
        table.insert(item, substring)
      end
      tmp[#tmp+1] = {tonumber(item[1]), tonumber(item[2]), tonumber(item[3]), tonumber(item[4]), item[5]}
    end
    dragTiles = tmp
    loading = false
  elseif loading and love.keyboard.isDown("escape") then
    loading = false
    loadinput = 1
  end
end

function love.draw()
  love.graphics.draw(back, backx, backy)
  love.graphics.setColor(0,0,0)
  if section == "outside" then
    love.graphics.print( "--> OUTDOORS (Q)", 1050, 10)
    love.graphics.print( "      INSIDE (W)", 1050, 30)
    love.graphics.print( "1 - Vegetation", 1200, 10)
    love.graphics.print( "2 - Ground", 1200, 30)
    love.graphics.print( "3 - Rocks", 1200, 50)
    love.graphics.print( "4 - Items", 1200, 70)
    love.graphics.print( "5 - Other/Walls", 1200, 90)
    love.graphics.print( "6 - Buildings", 1200, 110)
  elseif section == "interiorgeneral" then
    love.graphics.print( "     OUTDOORS (Q)", 1050, 10)
    love.graphics.print( "--> INSIDE (W)", 1050, 30)
    love.graphics.print( "1 - Walls", 1200, 10)
    love.graphics.print( "2 - Flooring", 1200, 30)
    love.graphics.print( "3 - Stairs", 1200, 50)
    love.graphics.print( "4 - Misc", 1200, 70)
    love.graphics.print( "5 - Electronics", 1200, 90)
    love.graphics.print( "6 - Tables", 1200, 110)
    love.graphics.print( "7 - Other", 1200, 130)
  end
  
  love.graphics.setColor(1,1,1)
  
  for i=1,#dragTiles do
    if dragTiles[i] == nil then 
    else
      img = spriteSheets[dragTiles[i][5]]
      quad = love.graphics.newQuad(dragTiles[i][3], dragTiles[i][4], 32, 32, img)
      love.graphics.draw(img, quad, dragTiles[i][1], dragTiles[i][2]) 
    end
  end
  
  love.graphics.setColor(0.8,0.8,0.8)
  love.graphics.rectangle("fill", 0, 0, 256, 1000 )
  
  
  love.graphics.setColor(1,1,1)
  love.graphics.draw(displayedSheet, 0, 0+scroll)
  
   
  
  if saving == true then
    love.graphics.draw(loadsaveback, 350, 200)
    love.graphics.setColor(0,0,0)
    love.graphics.print(">> "..saveinput..".proj", 380, 230)
    love.graphics.setColor(1,1,1)
  end
  
  if loading == true then
    love.graphics.draw(loadsaveback, 350, 200)
    love.graphics.setColor(0,0,0)
    
    count = 0
   
    for i=1,#files do
      if i >= shift and count <= 5 then
        if loadinput == i then 
          love.graphics.print(">"..files[i], 380, 220+(10*count))
          count = count + 1
        else
          love.graphics.print(" "..files[i], 380, 220+(10*count))
          count = count + 1
        end
      end
    end
    
    love.graphics.print(saveinput, 360, 210)
  end
  
  width, height = love.graphics.getDimensions( )
  love.graphics.setColor(0,0.5,0.5)
  love.graphics.rectangle("fill", 0, 920, 256, 80)
  love.graphics.draw(painttilebox, 256-80, 920, 0, 2, 2)
  love.graphics.setColor(1,1,1)
  
  if paintmode and paintTile[1] ~= nil then
    img = spriteSheets[paintTile[3]]
    quad = love.graphics.newQuad(paintTile[1], paintTile[2], 32, 32, img)
    love.graphics.draw(img, quad, 256-80+8, 920+8, 0, 2, 2)
  end
  
  love.graphics.setColor(0.9,0.9,0.9)
  love.graphics.rectangle("fill", 10, 932, 40, 25)
  love.graphics.rectangle("fill", 10, 962, 80, 25)
  love.graphics.rectangle("fill", 55, 932, 115, 25)
  love.graphics.setColor(0,0,0)
  love.graphics.print("Help", 15, 938)
  love.graphics.print("Paint Mode", 15, 968)
  love.graphics.print("Layer Mode - "..layermode, 59, 938)
  love.graphics.setColor(1,1,1)
end

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

function love.wheelmoved(x, y)
  width, height = displayedSheet:getDimensions( )
  if y > 0 and scroll < 500 then
      scroll = scroll + 64
  elseif y < 0 and scroll+height > 500 then
      scroll = scroll - 64
  end
end

function dirLookup(dir)
  files = {}      
  for file in io.popen('find "'..dir..'" -type f'):lines() do                         
    files[#files+1] = file
  end
  return files
end

--function sortByZIndex(table)
--  tmptable = {}
--  print("sort"..#table)
--  for i=1,#table do
--    print("awd"..table[i][5])
--    if table[i][6] == 0 then
--      tmptable[#tmptable+1] = table[i]
--    end
--  end
--  for i=1,#table do
--    if table[i][6] == 1 then
--      tmptable[#tmptable+1] = table[i]
--    end
--  end
--  print(#tmptable)
--  return tmptable
--end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      if x > 10 and x < 90 and y > 962 and y < 987 then
        if paintmode then paintmode = false
        else paintmode = true end
      end
      if x > 55 and x < 170 and y > 932 and y < 957 then
        if layermode == "bot" then layermode = "top"
        else layermode = "bot" end
      end
   end
end

function love.keypressed(key, code)
  if saving == true then
    if key == "backspace" then
      saveinput = saveinput:sub(1, -2)
    elseif key ~= "return" then
      saveinput = saveinput..key
    end
  elseif loading == true then
    files = dirLookup("projects")
    if key == "up" and loadinput ~= 1 then
      loadinput = loadinput - 1
      if loadinput > 5 then shift = shift - 1 end
    elseif key == "down" and loadinput < #files then
      loadinput = loadinput + 1
      if loadinput > 5 then shift = shift + 1 end
    end
  else
    if key == "escape" then
      love.event.push("quit")
    end
    if key == "y" then
      print(love.mouse.getPosition())
    end
    if key == "q" then
      section = "outside"
      displayedSheet = vegetation
    elseif key == "w" then
      section = "interiorgeneral"
      displayedSheet = walls
    end
    
    if key == "s" then
      saving = true
    end
    
    if key == "l" then
      loading = true
    end
    
    if section == "outside" then
      if key == "1" then displayedSheet = vegetation end
      if key == "2" then displayedSheet = groundtiles end
      if key == "3" then displayedSheet = rocks end
      if key == "4" then displayedSheet = items end
      if key == "5" then displayedSheet = othero end
      if key == "6" then displayedSheet = buildings end
    elseif section == "interiorgeneral" then
      if key == "1" then displayedSheet = walls end
      if key == "2" then displayedSheet = flooring end
      if key == "3" then displayedSheet = stairs end
      if key == "4" then displayedSheet = misc end
      if key == "5" then displayedSheet = electronics end
      if key == "6" then displayedSheet = tables end
      if key == "7" then displayedSheet = otheri end
    end
    if key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" then scroll = 0 end
  end
end