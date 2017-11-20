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

function Button(buttonStates, x, y, size)
   return {
	  {Sprite, buttonStates, x, y, size, size},
	  {SphereCollider, size/2},
	  {MouseListener}
   }
end

function PieButton(buttonStates, x, y, size, callback)
   return {
	  {Sprite, buttonStates, x, y, size, size},
	  {SphereCollider, size/2},
	  {PieMenuOption, callback},
	  {MouseListener}
   }
end


---------------------------------------------------------------------------

function TilePieMenu(owner)
   local buttonStates = {
	  ["Default"] = love.graphics.newImage("assets/tempButton.png"),
	  ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
   }
   local callback = {
	  function()
		 owner:add( Spawn() )
		 world:register( spawnGuarani() )
	  end,
	  function()
		 owner:add( Resource() )
		 world:register( showResourcesOptions() )
	  end,
	  function()
	  end,
	  function()
	  end
   }
	  
   local sprite    = owner:get "Sprite"
   local action    = owner:get "ActionMenu"
   local boardTile = owner:get "BoardTile"
   
   local pie = PieMenu(sprite.x +sprite.width/2,
					   sprite.y +sprite.height/2)

   local temp = {}
   for i=1, 4 do
	  local posX = pie.x +50*math.cos(i*math.pi/2) -PIE_BUTTON_SIZE/2
	  local posY = pie.y +50*math.sin(i*math.pi/2) -PIE_BUTTON_SIZE/2

	  if not boardTile.content then
		 temp[i] = PieButton(buttonStates, posX, posY, PIE_BUTTON_SIZE, callback[i])
	  end
   end
   
   local out = world:multiAssemble(temp)
   out:add( pie )
   out:add( action )
   out:add( SphereCollider(TILE_SIZE*0.2) ) --precalculed
   return out
end

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
