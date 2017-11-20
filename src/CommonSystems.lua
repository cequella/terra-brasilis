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

function roundHighlight()
   local self = System.requires {"Sprite", "SphereCollider", "MouseListener"}

   function self:load(entity)
	  local listener = entity:get "MouseListener"
	  local sprite   = entity:get "Sprite"

	  listener.oldState = sprite.state
   end
   function self:update(dt, entity)
	  local sprite   = entity:get "Sprite"
	  local collider = entity:get "SphereCollider"
	  local listener = entity:get "MouseListener"

	  listener.over = checkDotInSphere(love.mouse.getX()-(sprite.x+sprite.width/2),
									   love.mouse.getY()-(sprite.y+sprite.height/2),
									   collider.radius)

	  if listener.over then
		 sprite.state = "MouseOver"
	  else
		 sprite.state = listener.oldState
		 listener.oldState = sprite.state
	  end
   end

   return self
end

function callActionMenu()
   local self = System.requires {"Sprite", "MouseListener", "SphereCollider", "CallActionMenu"}

   function self:update(dt, entity)
	  if not love.mouse.isDown(1) then return end

	  local listener   = entity:get "MouseListener"
	  local actionMenu = entity:get "CallActionMenu"

	  if listener.over then
		 if actionMenu.piemenu then return end
		 local sprite   = entity:get "Sprite"
		 actionMenu.piemenu = world:multiAssemble( ActionPieMenu(entity) )
	  end
   end

   return self
end

function pieMenuManager()
   local self = System.requires {"PieMenu", "SphereCollider", "CallActionMenu"}

   function self:update(dt, entity)
	  local piemenu  = entity:get "PieMenu"
	  local collider = entity:get "SphereCollider"
	  local owner    = entity:get "CallActionMenu"

	  local over = checkDotInSphere(love.mouse.getX()-piemenu.x,
									love.mouse.getY()-piemenu.y,
									collider.radius)
	  
	  if love.mouse.isDown(1) and not over then
		 owner.piemenu = nil
		 entity:destroy()
	  end

   end
   
   return self
end
