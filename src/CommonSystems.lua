require "PieMenuSystem"

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

function playerUI()
   local self = System.requires {"Player"}

   function self:load(entity)
      local player = entity:get "Player"

      player.clockEntity = world:assemble( WorldClock() )
   end
   
   function self:update(entity)
      local player = entity:get "Player"

      -- Update Clock
      player.clock = player.clock +0.1

      -- Show Resources Options
      if player.state == "ResourceCollecting" then
	 local windowWidth = love.graphics.getWidth()
	 local spacement = 0.025*windowWidth
	 local cWidth    = 0.750*(windowWidth -2*spacement)/3
	 local cHeight   = 1.618*cWidth
	 local initX     = 0.125*windowWidth

	 for i=0, 2 do
	    world:assemble( ResourceCard(initX +i*(spacement+cWidth), 100) )
	 end

	 player.state = nil
      end
   end

   return self
end

function showHelp()
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

function callResourceCollection()
   
end
