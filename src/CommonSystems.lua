world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

-- Constants
local TILE_SIZE           = 96
local PIEMENU_BUTTON_SIZE = 30
local PIEMENU_DIAMETER    = 48
-- /Constants

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
   local self = System.requires {"Sprite", "MouseListener", "SphereCollider"}

   function self:mouseMoved(entity, x, y)
      local listener = entity:get "MouseListener"
      local sprite   = entity:get "Sprite"
      local collider = entity:get "SphereCollider"
      listener.over  = checkDotInSphere(love.mouse.getX()-(sprite.x+sprite.width/2),
					love.mouse.getY()-(sprite.y+sprite.height/2),
					collider.radius)      
   end
   function self:load(entity)
      local listener = entity:get "MouseListener"
      local sprite   = entity:get "Sprite"

      listener.oldState = sprite.state
   end
   function self:update(entity, dt)
      local sprite   = entity:get "Sprite"
      local collider = entity:get "SphereCollider"
      local listener = entity:get "MouseListener"

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
   local self = System.requires {"BoardTile", "MouseListener"}
   
   function self:update(entity, dt)
      local listener  = entity:get "MouseListener"
      if not (VersionFlavour.leftClick() and listener.over) then return end

      local sprite       = entity:get "Sprite"
      local posX         = sprite.x -PIEMENU_BUTTON_SIZE/2 +sprite.width/2 
      local posY         = sprite.y -PIEMENU_BUTTON_SIZE/2 +sprite.height/2
      local buttonStates = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
      }

      local callback = function() print("Clicou, clicou, clicou... pode comemorar!") end
      for i=1, 4 do
	 local xDisp = PIEMENU_DIAMETER*math.cos(i*math.pi/2) 
	 local yDisp = PIEMENU_DIAMETER*math.sin(i*math.pi/2)
	 local temp = world:assemble( RoundButton(buttonStates, posX+xDisp, posY+yDisp, PIEMENU_BUTTON_SIZE, callback) )
	 temp:add( ActionOption() )
      end

      world:register( Test() )
      world:unregister( self )
   end

   return self
end

function Test()
   local self = System.requires {"ButtonCallback", "MouseListener"}

   function self:update(entity, dt)
      local listener = entity:get "MouseListener"
      if not VersionFlavour.leftClick() then return end
      
      if listener.over then
	 local button = entity:get "ButtonCallback"
	 button.callback()
      end

      local list = world:getAllWith {"ActionOption"}
      for _, option in ipairs(list) do
	 option:destroy()
      end

      world:register( callActionMenu() )
      world:unregister( self )
   end

   return self
end
