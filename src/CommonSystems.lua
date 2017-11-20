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
   local self = System.requires {"BoardTile"}

   function self:update(dt, entity)
	  if not love.mouse.isDown(1) then return end

	  local listener   = entity:get "MouseListener"
	  local actionMenu = entity:get "ActionMenu"

	  if listener.over then
		 if actionMenu.caller then return end
		 actionMenu.caller = world:multiAssemble( TilePieMenu(entity) )
		 world:register( pieMenuManager() )
	  end
   end

   return self
end

function pieMenuManager()
   local self = System.requires {"PieMenu"}

   function self:load()
	  world:register( pieOptionSelect() )
   end
   function self:update(dt, entity)
	  local piemenu  = entity:get "PieMenu"
	  local collider = entity:get "SphereCollider"
	  local owner    = entity:get "ActionMenu"
	  
	  local over = checkDotInSphere(love.mouse.getX()-piemenu.x,
									love.mouse.getY()-piemenu.y,
									collider.radius)
	  
	  if love.mouse.isDown(1) and not over and owner.caller then
		 owner.caller:destroy()
		 owner.caller= nil
		 entity:destroy()
	  end
   end
   
   return self
end

function pieOptionSelect()
   local self = System.requires {"PieMenuOption"}

   function self:update(dt, entity)
	  local option   = entity:get "PieMenuOption"
	  local collider = entity:get "SphereCollider"
	  local listener = entity:get "MouseListener"

	  -----
	  local piemenu = world:getAllWith {"PieMenu"}[1]
	  local owner   = piemenu:get "ActionMenu"
	  -----
	  
	  if love.mouse.isDown(1) and listener.over and owner.caller then
		 option:callback()
		 owner.caller:destroy()
		 owner.caller= nil
		 piemenu:destroy()

		 world:unregister( self )
		 world:unregister( pieMenuManager() )
	  end
   end
   
   return self
end

function spawnGuarani()
   local self = System.requires {"BoardTile", "Spawn"}

   function self:update(dt, entity)
	  local sprite    = entity:get "Sprite"
	  local boardTile = entity:get "BoardTile"

	  local guarani = Guarani(sprite.x+(sprite.width-64)/2, sprite.y+(sprite.height-64)/2)
	  boardTile.content = world:assemble( guarani )
	  world:unregister( self )
   end

   return self
end

function showResourcesOptions()
   local self = System.requires {"Resource"}

   function self:draw(entity)
	  local width     = (love.graphics.getWidth()*0.8)/3
	  local height    = width*1.618
	  local posX      = love.graphics.getWidth()*0.05
	  local spacement = love.graphics.getWidth()*0.05

	  for i=0, 2 do
		 love.graphics.rectangle("fill", posX +i*(width+spacement), 20,
								 width, height,
								 3, 3,
								 3)
		 love.graphics.rectangle("line", love.graphics.getWidth()*0.1, 40+height,
								 love.graphics.getWidth()*0.8, 100)
	  end
   end
   
   return self
end
