InGameAction = {}

function InGameAction.spawnAction()
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
function InGameAction.moveAction()
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
function InGameAction.collectAction()
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
function InGameAction.attackAction()
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
function InGameAction.upgradeAction()
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
