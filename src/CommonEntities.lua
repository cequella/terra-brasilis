world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96
local PIE_BUTTON_SIZE = 30

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

function RoundButton(buttonStates, x, y, size, callback)
   local hSize = size/2

   if callback then
	  return {
		 {Sprite, buttonStates, x, y, size, size},
		 {SphereCollider, x +hSize, y +hSize, hSize},
		 {ButtonCallback, callback},
		 {MouseListener}
	  }
   else
	  return {
		 {Sprite, buttonStates, x, y, size, size, "MouseOver"},
	  }
   end
end

---------------------------------------------------------------------------

function Board(x, y, xCount, yCount)
   local temp = {}

   local xDisplacement = TILE_SIZE*0.875 --precalculed
   local yDisplacement = TILE_SIZE*0.75  --precalculed
   
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
