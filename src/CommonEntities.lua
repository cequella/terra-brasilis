world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96

function Paw(faction, x, y)
   local charset = (faction=="Guarani") and cache.guarani or nil
   
   return {
      {Sprite, charset, x, y, cache.PAW_SIZE, cache.PAW_SIZE}
   }
end

function Tile(tileStates, x, y, size)
   local hSize = size/2
   return {
      {Sprite, tileStates, x, y, size, size},
      {SphereCollider, x +hSize, y +hSize, size*0.3},
      {BoardTile}
   }
end

function Player()
   return {
      {PlayerComponent}
   }
end

function RoundButton(buttonStates, x, y, size, callback, help)
   local hSize = size/2

   if callback then
      return {
	 {Sprite, buttonStates, x, y, size, size},
	 {SphereCollider, x +hSize, y +hSize, hSize},
	 {ButtonCallback, callback},
	 {UIHelp, help, "right"},
	 {MouseListener}
      }
   else
      return {
	 {Sprite, buttonStates, x, y, size, size, "Unable"},
      }
   end
end

function ResourceCard(x, y)
   local spacement = 0.025*love.graphics.getWidth()
   local cWidth    = 0.750*(love.graphics.getWidth()-2*spacement)/3
   local cHeight   = 1.618*cWidth

   return {
      {Sprite, cache.card, x, y, cWidth, cHeight}
   }
end

function WorldClock()
   local image = cache.clock
   local posX = (love.graphics.getWidth()-image:getWidth() )/2
   local posY = -image:getHeight()/2
   return {
      {Sprite, image, posX, posY, 200, 200}
   }
end

---------------------------------------------------------------------------

function Board(x, y, xCount, yCount)
   local temp = {}

   local xDisplacement = TILE_SIZE*0.875 --precalculed
   local yDisplacement = TILE_SIZE*0.750 --precalculed
   
   for i=0, xCount-1 do
      for j=0, yCount-1 do
	 local posX = (i%2==0) and x +j*xDisplacement or x +xDisplacement*(j+0.5)
	 local posY = y +i*yDisplacement
	 
	 temp[i+j*xCount +1] = Tile(cache.tileImage, posX, posY, TILE_SIZE)
      end
   end

   local out = world:multiAssemble( temp )
   return out
end
