world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96
local PIE_BUTTON_SIZE = 30

function Guarani(x, y)
   return {
      {Sprite, love.graphics.newImage("assets/bart.png"), x, y, 64, 64}
   }
end

function Tile(tileStates, x, y, size)
   return {
      {Sprite, tileStates, x, y, TILE_SIZE, TILE_SIZE},
      {SphereCollider, TILE_SIZE*0.3},
      {MouseListener},
      {BoardTile},
      {ActionMenu}
   }
end

function RoundButton(buttonStates, x, y, size, callback)
   return {
      {Sprite, buttonStates, x, y, size, size},
      {SphereCollider, size/2},
      {ButtonCallback, callback},
      {MouseListener}
   }
end

---------------------------------------------------------------------------

function Board(x, y, xCount, yCount)
   local temp = {}

   local tileStates = {
      ["Default"]   = love.graphics.newImage("assets/tile.png"),
      ["MouseOver"] = love.graphics.newImage("assets/tileS.png"),
      ["Denied"]    = love.graphics.newImage("assets/tileD.png")
   }
   local xDisplacement = TILE_SIZE*0.875 --precalculed
   local yDisplacement = TILE_SIZE*0.75  --precalculed
   
   for i=0, xCount-1 do
      for j=0, yCount-1 do
	 local posX = (i%2==0) and x +j*xDisplacement or x +xDisplacement*(j+0.5)
	 local posY = y +i*yDisplacement
	 
	 temp[i+j*xCount +1] = Tile(tileStates, posX, posY)
      end
   end

   local out = world:multiAssemble( temp )
   return out
end
