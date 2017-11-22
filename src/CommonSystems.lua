world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

function render()
   local self = System.requires {"Sprite"}

   function self:draw(entity)
      local sprite   = entity:get "Sprite"

      love.graphics.draw(sprite.image[sprite.state],
			 sprite.x, sprite.y,
			 0,
			 sprite.sx, sprite.sy)
   end

   return self
end

function uiHelp()
   local self = System.requires {"Sprite", "UIHelp"}

   function self:draw(entity)
      local sprite = entity:get "Sprite"
      local uiHelp = entity:get "UIHelp"
      
      if uiHelp.timeOver>0 then
	 local font   = love.graphics.getFont()
	 local deltaT = love.timer.getTime() -uiHelp.timeOver
	 if deltaT<0.4 then return end -- 0.4 seconds
	    
	 local posX
	 local posY
	 
	 -- At right
	 posX = sprite.x +sprite.width+10
	 posY = sprite.y +(sprite.height -font:getHeight())/2

	 -- Draw rectangle
	 love.graphics.setColor(0, 0, 0, 180)
	 love.graphics.rectangle("fill",
				 posX -5, posY -5,
				 font:getWidth(uiHelp.message) +10, font:getHeight() +10)
	 
	 -- Write text
	 love.graphics.setColor(255, 255, 255)
	 love.graphics.print(uiHelp.message, posX, posY)
      end
   end

   return self
end


function roundHighlight()
   local self = System.requires {"Sprite", "SphereCollider"}

   function self:mouseMoved(entity, x, y)
      local sprite   = entity:get "Sprite"
      local collider = entity:get "SphereCollider"
      local over     = checkDotInSphere(x -collider.x,
					y -collider.y,
					collider.radius)
      
      sprite.state = over and "MouseOver" or "Default"
   end

   return self
end

function tilePieMenu()
   local self = System.requires {"BoardTile", "SphereCollider"}

   local function moveSelected(tile, sprite)
      local stateList = cache.pieMenu.move
      local callback
      
      if tile.content then -- not empty
	 callback = nil
      else
	 local posX = sprite.x +(sprite.width-cache.PAW_SIZE)/2
	 local posY = sprite.y +(sprite.height-cache.PAW_SIZE)/2
	 
	 callback = function()
	    tile.content = world:assemble( Paw("Guarani", posX, posY) )
	 end   
      end

      return stateList, callback, "Move"
   end
   
   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local tile     = entity:get "BoardTile"
      local collider = entity:get "SphereCollider"
      local sprite   = entity:get "Sprite"
      local over     = checkDotInSphere(x -collider.x,
					y -collider.y,
					collider.radius)
      if not over then return end

      local centerX = sprite.x -cache.PIEMENU_BUTTON_SIZE/2 +sprite.width/2 
      local centerY = sprite.y -cache.PIEMENU_BUTTON_SIZE/2 +sprite.height/2

      entity.piemenu = {}
      for i=1, 4 do
	 local xDisp = cache.PIEMENU_RADIUS*math.cos(i*math.pi/2) 
	 local yDisp = cache.PIEMENU_RADIUS*math.sin(i*math.pi/2)

	 -- Spawn option
	 local stateList, callback, help
	 if i == 1 then
	    stateList, callback, help = moveSelected(tile, sprite)
	 elseif i == 2 then
	    help = "Attack"
	    callback = function() print("Attack") end
	    stateList = cache.pieMenu.attack
	 elseif i == 3 then
	    help = "Resource"
	    callback = function() print("Resource") end
	    stateList = cache.pieMenu.resource
	 else --if i == 4 then
	    help = "Upgrade"
	    callback = function() print("Upgrade") end
	    stateList = cache.pieMenu.upgrade
	 end

	 local temp = RoundButton(cache.pieMenu.move,
				  centerX +xDisp, centerY +yDisp,
				  cache.PIEMENU_BUTTON_SIZE,
				  callback, help)
	 table.insert(entity.piemenu, world:assemble(temp))
      end

      world:register( pieMenuManagement(entity, collider.x, collider.y) )
      world:unregister( self )
   end

   return self
end

function pieMenuManagement(owner, centerX, centerY)
   local self = System.requires {"ButtonCallback", "SphereCollider", "UIHelp"}

   function self:mouseMoved(entity, x, y)
      local collider = entity:get "SphereCollider"
      local button   = entity:get "ButtonCallback"
      local uiHelp   = entity:get "UIHelp"

      local over = checkDotInSphere(x -collider.x,
				    y -collider.y,
				    collider.radius)

      if over then
	 if uiHelp.timeOver==0 then
	    uiHelp.timeOver = love.timer.getTime()
	 end
      else
	 uiHelp.timeOver = 0
      end
   end
   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local collider = entity:get "SphereCollider"
      local over = checkDotInSphere(x -collider.x,
				    y -collider.y,
				    collider.radius)
      local inPieRadius = checkDotInSphere(x -centerX,
					   y -centerY,
					   cache.PIEMENU_RADIUS +cache.PIEMENU_BUTTON_SIZE)
      
      if over then
	 local button = entity:get "ButtonCallback"
	 button.callback()
      end
      if over == inPieRadius then -- if over XOR !inPieRadius (clear)
	 for _, option in ipairs(owner.piemenu) do
	    option:destroy()
	 end
	 
	 world:register( tilePieMenu() )
	 world:unregister( self )
      end
   end

   return self
end
