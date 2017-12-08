require "ecs.World"

require "CommonSystems"
require "CommonEntities"

require "InGameMenus"

InGameWorld = {}
setmetatable(InGameWorld,{
				__index = InGameWorld,
				__call = function(instance)
				   local self = World()
				   
				   self
					  :register( render() )
					  :register( roundHighlight() )
					  :register( squareHighlight() )
					  :register( rectButtonCallbackExecute() )
					  :register( roundButtonCallbackExecute() )
					  :register( showHelp() )
					  :register( InGame.innerMenu() )
					  :register( InGameWorld.drawPawnStatus() )
					  :register( InGameWorld.drawResourcesMarker() )
					  :register( InGameWorld.playerGameflow() )

				   self:assemble( Game() )

				   return self
				end
						 }
)
function InGameWorld.pcGameflow()
   local self = System.requires {"GameState"}

   function self:update(entity, dt)
	  local state = entity:get "GameState"

	  --print(tostring(state.dt))
	  
	  if state.dt == nil then
		 state.dt = dt
		 return
	  end
	  state.dt = state.dt +dt

	  if state.dt > 1 then
		 local board = world:getAllWith {"BoardTile"}
		 local tile = board[1]
		 local boardTile = tile:get "BoardTile"

		 if boardTile.faction == nil then
			local sprite = tile:get "Sprite"
			boardTile.faction = "Bandeirante"
			boardTile.entity = world:assemble( Bandeirante(sprite.x +18, sprite.y +9) )
		 end
	  end
	  if state.dt > 2 then
		 local board = world:getAllWith {"BoardTile"}
		 local tile = board[2]
		 local boardTile = tile:get "BoardTile"

		 if boardTile.faction == nil then
			local sprite = tile:get "Sprite"
			boardTile.faction = "Bandeirante"
			boardTile.entity = world:assemble( Bandeirante(sprite.x +18, sprite.y +9) )
		 end
	  end
	  if state.dt > 3 then
		 local board = world:getAllWith {"BoardTile"}
		 local tile = board[3]
		 local boardTile = tile:get "BoardTile"

		 if boardTile.faction == nil then
			local sprite = tile:get "Sprite"
			boardTile.faction = "Bandeirante"
			boardTile.entity = world:assemble( Bandeirante(sprite.x +18, sprite.y +9) )
		 end
	  end
	  if state.dt > 4 then
		 state.dt = nil
		 world
			:unregister(self.__index)
			:register( InGameWorld.playerGameflow() )
			:register( InGame.callPieMenu() )
	  end
   end
   return self
end
function InGameWorld.playerGameflow()
   local self = System.requires {"GameState"}

   function self:load(entity)
	  local game = entity:get "GameState"

	  world
		 --:register( InGameWorld.pcGameflow() )
		 :register( InGame.callPieMenu() )
	  
	  -- Background
	  world:assemble( Prop(cache.background,
						   0, 0,
						   cache.background:getWidth(), cache.background:getHeight()) )

	  -- Board
	  local xStep = cache.TILE_SIZE*0.875
	  local yStep = cache.TILE_SIZE*0.750   
	  local hSize = cache.TILE_SIZE/2
	  local oca = {}
	  for i=0, 5 do
		 for j=0, 5 do
			local coord = i*6+j
			local posX = (i%2==0) and 120 +j*xStep or 120 +xStep*(j+0.5)
			local posY = 135 +i*yStep
			
			local faction = nil
			if coord==27 then
			   oca={x=posX, y=posY}
			   faction="Oca"
			end
			local tile = world:assemble( Tile(cache.tileImage, posX, posY, coord, faction) )
		 end
	  end

	  -- Oca
	  world:assemble( Prop(cache.guarani,
						   oca.x+18, oca.y+9,
						   cache.PAWN_SIZE, cache.PAWN_SIZE) )

	  -- Clock
	  world:assemble( WorldClock() )

	  -- HUD
	  world:assemble( Prop(cache.frame, 0, 0, cache.frame:getWidth(), cache.frame:getHeight()) )

	  -- Adversity
	  world:assemble( RectangleButton(game.currentAdversity.image,
									  200, 0,
									  game.currentAdversity.image:getWidth()*0.15,
									  game.currentAdversity.image:getHeight()*0.15,
									  function() end,
									  game.currentAdversity.name, "AtBottom") )
   end
   function self:update(entity, dt)
	  local state = entity:get "GameState"
	  
	  if state.needUpdate then
		 state.needUpdate = false
	  end
	  
	  if state.turnCount == 3 then
		 state.turnCount = 0
		 world
			:unregister( self.__index )
			:unregister( "callPieMenu" )
			:register( InGameWorld.pcGameflow() )
	  end
   end
   function self:drawUI(entity)
	  local game = entity:get "GameState"
	  love.graphics.print(tostring(game.turnCount), 100, 100)
   end
   
   return self
end
function InGameWorld.drawResourcesMarker()
   local self = System.requires {"GameState", "Resource"}
   function self:drawUI(entity)
      local resource = entity:get "Resource"

      local tempFont = love.graphics.getFont();
      local topMargin = 510
      
      love.graphics.setFont(cache.uiFont)
	  for i=2, 4 do
		 love.graphics.print(tostring(resource.amount[2]), 60, topMargin +(i-2)*22)
	  end
      love.graphics.setFont(tempFont)
   end
   return self
end
function InGameWorld.drawPawnStatus()
   local self = System.requires {"Pawn"}

   function self:mouseMoved(entity, x, y)
	  local pawn = entity:get "Pawn"
	  local sprite = entity:get "Sprite"
	  pawn.over = checkDotInSphere(x, y,
								   sprite.x, sprite.y,
								   cache.PAWN_SIZE)
   end
   function self:drawUI(entity)
	  local sprite = entity:get "Sprite"
	  local pawn = entity:get "Pawn"

	  if not pawn.over then return end
	  for i=1, pawn.life do
		 love.graphics.draw(cache.lifeIcon, sprite.x, sprite.y+(i-1)*8, 0.0, 0.02, 0.02)
	  end
   end

   return self
end

---------------------------------------------------- Gameflow
function InGameWorld.coordToIndex(i, j)
   return j*6+i+1
end
function InGameWorld.indexToCoord(index)
   local i = index%6
   local j = (index -i)/6
   return i, j
end
function InGameWorld.needUpdate(where)
   local game = world:getAllWith {"GameState"}[1]:get "GameState"
   game.needUpdate = where
end
function InGameWorld.updateTurn(cost)
   local game = world:getAllWith {"GameState"}[1]
   local state = game:get "GameState"
   local resource = game:get "Resource"
   
   state.turnCount  = state.turnCount  +1
   for i=1, 4 do resource.amount[i] = resource.amount[i] +cost[i] end
end
function InGameWorld.spawnPoint()
   local board = world:getAllWith {"BoardTile"}
   local possible = {21, 22, 27, 29, 33, 34}

   for _,i in ipairs(possible) do
	  local tile = board[i]:get "BoardTile"
	  if tile.faction == nil then
		 return i
	  end
   end

   return nil
end
function InGameWorld.neighborhood(tileCoord)
   local i, j = InGameWorld.indexToCoord(tileCoord)
   local around = {}

   if j%2==0 then

	  -- Super
	  if j-1 >= 0 then
		 table.insert(around, {x=i, y=j-1})
		 if i-1>0 then
			table.insert(around, {x=i-1, y=j-1})
		 end
	  end

	  -- Infer
	  if j+1 < 6 then
		 table.insert(around, {x=i, y=j+1})
		 if i-1>0 then
			table.insert(around, {x=i-1, y=j+1})
		 end
	  end
	  
   else

	  -- Super
	  if j-1 >= 0 then
		 table.insert(around, {x=i, y=j-1})
		 if i+1<6 then
			table.insert(around, {x=i+1, y=j-1})
		 end
	  end

	  -- Infer
	  if j+1 < 6 then
		 table.insert(around, {x=i, y=j+1})
		 if i+1<6 then
			table.insert(around, {x=i+1, y=j+1})
		 end
	  end
	  
   end
   
   if i-1>0 then
	  table.insert(around, {x=i-1, y=j})
   end
   if i+1<6 then
	  table.insert(around, {x=i+1, y=j})
   end

   return around
end
function InGameWorld.targetList(tileCoord)
   local i = tileCoord%6
   local j = (tileCoord -i)/6
   local around = InGameWorld.neighborhood(tileCoord)

   local board = world:getAllWith {"BoardTile"}
   
   local out = {}
   for _,i in ipairs(around) do
	  local coord = i.y*6 +i.x +1
	  local temp = board[coord]:get "BoardTile"
	  if temp.faction == "Bandeirante" then
		 table.insert(out, coord)
	  end
   end

   if #out>0 then
	  return out
   else
	  return nil
   end
end
