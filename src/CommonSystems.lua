require "PieMenuSystem"
require "InGameSystem"

world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

function render()
   local self = System.requires {"Sprite"}

   function self:draw(entity)
      local sprite   = entity:get "Sprite"

	  love.graphics.setColor(sprite.color)
      love.graphics.draw(sprite.image,
						 sprite.x, sprite.y,
						 0,
						 sprite.sx, sprite.sy)
   end

   return self
end

function showHelp()
   local self = System.requires {"Sprite", "UIHelp"}

   function self:update(entity)
	  local sprite = entity:get "Sprite"
	  local uiHelp = entity:get "UIHelp"

	  if sprite.state == "MouseOver" then
		 if uiHelp.timeOver==0 then
			uiHelp.timeOver = love.timer.getTime()
		 end
      else
		 uiHelp.timeOver = 0
      end
   end
   function self:draw(entity)
      local sprite = entity:get "Sprite"
      local uiHelp = entity:get "UIHelp"

	  if not uiHelp.message then return end
      if uiHelp.timeOver>0 then
		 local font   = love.graphics.getFont()
		 local deltaT = love.timer.getTime() -uiHelp.timeOver
		 if deltaT<cache.feedback then return end
		 
		 local posX
		 local posY
		 
		 -- Positioning
		 if uiHelp.position == "AtRight" then
			posX = sprite.x +sprite.width +10
			posY = sprite.y +(sprite.height -font:getHeight())/2
		 elseif uiHelp.position == "AtBottom" then
			posX = sprite.x +(sprite.width -font:getWidth(uiHelp.message))/2
			posY = sprite.y +sprite.height +10
		 elseif uiHelp.position == "AtTop" then
			posX = sprite.x +(sprite.width -font:getWidth(uiHelp.message))/2
			posY = sprite.y -font:getHeight() -10
		 elseif uiHelp.position == "AtLeft" then
			posX = sprite.x -font:getWidth(uiHelp.message) -10
			posY = sprite.y +(sprite.height -font:getHeight())/2
		 end

		 -- Draw rectangle
		 love.graphics.setColor(0, 0, 0, 180)
		 love.graphics.rectangle("fill",
								 posX -5, posY -5,
								 font:getWidth(uiHelp.message) +10, font:getHeight() +10,
								 6,6,3)
		 
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
      
      sprite.color = over and collider.color or {255,255,255}
	  sprite.state = over and "MouseOver" or "Default"
   end

   return self
end

function squareHighlight()
   local self = System.requires {"Sprite", "AABBCollider"}

   function self:mouseMoved(entity, x, y)
      local sprite   = entity:get "Sprite"
      local collider = entity:get "AABBCollider"
      local over     = checkDotInRect(x, y,
									  collider.x, collider.y,
									  collider.width, collider.height)

	  sprite.color = over and collider.color or {255,255,255}
	  sprite.state = over and "MouseOver" or "Default"
   end

   return self
end
