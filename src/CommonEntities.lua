world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96
local PIE_BUTTON_SIZE = 30

function Bart()

end

function Tile(tileStates, x, y, size)
   return {
	  {Sprite, tileStates, x, y, TILE_SIZE, TILE_SIZE},
	  {SphereCollider, TILE_SIZE*0.4},
	  {MouseListener},
	  {CallActionMenu}
   }
end

function PieButton(buttonStates, x, y)
   return {
	  {Sprite, buttonStates, x, y, PIE_BUTTON_SIZE, PIE_BUTTON_SIZE},
	  {SphereCollider, PIE_BUTTON_SIZE/2},
	  {MouseListener}
   }
end

---------------------------------------------------------------------------

function ActionPieMenu(owner)
   local buttonStates = {
	  ["Default"] = love.graphics.newImage("assets/tempButton.png"),
	  ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
   }

   local sprite   = owner:get "Sprite"
   local action   = owner:get "CallActionMenu"
   
   local pie = PieMenu(sprite.x +(sprite.width-PIE_BUTTON_SIZE)/2,
					   sprite.y +(sprite.height-PIE_BUTTON_SIZE)/2)
   
   local out = world:multiAssemble(
	  {
		 PieButton(buttonStates, pie.x,    pie.y-50),
		 PieButton(buttonStates, pie.x+50, pie.y),
		 PieButton(buttonStates, pie.x,    pie.y+50),
		 PieButton(buttonStates, pie.x-50, pie.y)
	  }
   )
   out:add( pie )
   out:add( action )
   --out:add( position )
   out:add( SphereCollider(50) )
   return out
end

function Board(x, y, xCount, yCount)
   local temp = {}

   local tileStates = {
	  ["Default"]   = love.graphics.newImage("assets/tile.png"),
	  ["MouseOver"] = love.graphics.newImage("assets/tileS.png"),
	  ["Denied"]    = love.graphics.newImage("assets/tileD.png")
   }
   local xDisplacement = TILE_SIZE*0.875
   local yDisplacement = TILE_SIZE*0.75
   
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
