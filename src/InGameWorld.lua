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
					  :register( InGameWorld.gameflow() )
					  :register( InGameWorld.drawPawnStatus() )
					  :register( InGame.innerMenu() )

				   self:assemble( Game() )

				   return self
				end
						 }
)
function InGameWorld.gameflow()
   local self = System.requires {"GameState"}

   function self:load(entity)
	  local game = entity:get "GameState"

	  -- Background
	  world:assemble( Prop(cache.background,
						   0, 0,
						   cache.background:getWidth(), cache.background:getHeight()) )

	  -- Board
	  local xStep = cache.TILE_SIZE*0.875
	  local yStep = cache.TILE_SIZE*0.750   
	  local hSize = cache.TILE_SIZE/2
	  local oca = {}
	  local band = {}
	  for i=0, 5 do
		 for j=0, 5 do
			local coord = i*6+j
			local posX = (i%2==0) and 120 +j*xStep or 120 +xStep*(j+0.5)
			local posY = 135 +i*yStep
			
			local faction = nil
			if coord==27 then
			   oca={x=posX, y=posY}
			   faction="Oca"
			elseif coord==19 then
			   band={x=posX, y=posY}
			   faction="Bandeirante"
			end
			local tile = world:assemble( Tile(cache.tileImage, posX, posY, coord, faction) )
		 end
	  end

	  -- Oca
	  world:assemble( Prop(cache.guarani,
						   oca.x+18, oca.y+9,
						   cache.PAWN_SIZE, cache.PAWN_SIZE) )
	  world:register( InGame.callPieMenu() )

	  -- Bandeirante
	  local board = world:getAllWith {"BoardTile"}
	  local temp = board[20]:get "BoardTile"
	  temp.entity = world:assemble( Bandeirante(band.x +18, band.y +9) )
	  
	  -- Clock
	  world:assemble( WorldClock() )

	  -- HUD
	  world:assemble( Prop(cache.frame, 0, 0, cache.frame:getWidth(), cache.frame:getHeight()) )
	  world:register( InGameWorld.drawResourcesMarker() )

	  -- Adversity
	  world:assemble( RectangleButton(game.currentAdversity.image,
									  200, 0,
									  game.currentAdversity.image:getWidth()*0.15,
									  game.currentAdversity.image:getHeight()*0.15,
									  function() end,
									  game.currentAdversity.name, "AtBottom") )
   end
   function self:update(entity, dt)
	  local game = entity:get "GameState"
	  if not game.needUpdate then return end

	  --[[
	  if game.needUpdate == "Board" then
		 local board = world:getAllWith {"BoardTile"}
		 for i=1, #board do
			local temp = board[i]:get "BoardTile"
			if temp.faction == "Bandeirante" then
			   temp = board[i]:get "SphereCollider"
			   temp.highlight = {255, 0, 0}
			elseif temp.faction == "Oca" then
			   temp = board[i]:get "SphereCollider"
			   temp.highlight = {0, 255, 255}
			end
		 end
	  end
	  --]]
	  
	  game.needUpdate = false
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
      love.graphics.print(tostring(resource.mineral), 60, topMargin)
      love.graphics.print(tostring(resource.vegetal), 60, topMargin+22)
      love.graphics.print(tostring(resource.animal),  60, topMargin+44)
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
function InGameWorld.needUpdate(where)
   local game = world:getAllWith {"GameState"}[1]:get "GameState"
   game.needUpdate = where
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
   local j = tileCoord%6
   local i = (tileCoord -j)/6
   local around = {}

   if i-1>0 then
	  table.insert(around, {x=j, y=i-1})
	  if j+1<6 then
		 table.insert(around, {x=j+1, y=i-1})
	  end
   end

   if i-1>0 then
	  table.insert(around, {x=j-1, y=i})
   end
   if i+1<6 then
	  table.insert(around, {x=j+1, y=i})
   end

   if i+1<6 then
	  table.insert(around, {x=j, y=i+1})
	  if j+1<6 then
		 table.insert(around, {x=j+1, y=i+1})
	  end
   end
   return around
end
function InGameWorld.targetList(tileCoord)
   local j = tileCoord%6
   local i = (tileCoord -j)/6
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
