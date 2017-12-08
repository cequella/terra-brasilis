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
function InGameWorld.spawnAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local tile = world:getAllWith {"BoardTile"}[action.info.spawnpoint]

	  -- Conf boardtile component
	  local description = tile:get "BoardTile"
	  local sprite = tile:get "Sprite"
	  
	  description.faction = "Guarani"
	  description.entity = world:assemble( Guarani(sprite.x +18, sprite.y +9) )
	  
	  entity:destroy()
	  world:unregister(self.__index)
   end

   return self
end
function InGameWorld.moveAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local tile = world:getAllWith {"BoardTile"}[action.info.from]

	  -- Conf boardtile component
	  local description = tile:get "BoardTile"
	  description.faction = nil
	  description.entity:destroy()

	  tile = world:getAllWith {"BoardTile"}[action.info.to]
	  description = tile:get "BoardTile"
	  description.faction = "Guarani"
	  
	  -- Use sprite component
	  local sprite = tile:get "Sprite"
	  description.entity = world:assemble( Guarani(sprite.x +18, sprite.y +9) )

	  entity:destroy()
	  world:unregister(self.__index)
   end

   return self
end
function InGameWorld.collectAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local game = world:getAllWith {"GameState"}[1]

	  local resource   = game:get "Resource"
	  resource.mineral = resource.mineral +action.info.mineral
	  resource.vegetal = resource.vegetal +action.info.vegetal
	  resource.animal  = resource.animal  +action.info.animal
	  
	  entity:destroy()
	  world:unregister(self.__index)
   end

   return self
end
function InGameWorld.attackAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local board = world:getAllWith {"BoardTile"}
	  local tile = board[action.info.at]

	  -- get coords
	  local i = action.info.at%6
	  local j = (action.info.at -i)/6
	  local around = {{x=i, y=j-1}, {x=i+1, y=j-1}, {x=i-1, y=j}, {x=i+1, y=j}, {x=i, y=j+1}, {x=i+1, y=j+1}}

	  for _,coord in ipairs(around) do
		 local temp = board[coord.y*6 +coord.x +1]:get "BoardTile"
		 if temp.faction == "Bandeirante" then
			local pawn = temp.entity:get "Pawn"
			pawn.life = pawn.life -1
			if pawn.life == 0 then
			   temp.entity:destroy()
			   temp.faction = nil
			end
		 end
	  end
	  
	  entity:destroy()
	  world:unregister(self.__index)
   end

   return self
end
function InGameWorld.upgradeAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local tile = world:getAllWith {"BoardTile"}[action.info.at]
	  local content = tile:get "BoardTile"
	  local pawn = content.entity:get "Pawn"
	  pawn.life = pawn.life +1
	  
	  entity:destroy()
	  world:unregister(self.__index)
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
		 love.graphics.draw(cache.lifeIcon, sprite.x+(i-1)*8, sprite.y, 0.0, 0.02, 0.02)
	  end
   end

   return self
end

---------------------------------------------------- Gameflow

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
