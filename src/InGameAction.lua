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
function InGameAction.moveActionStart()
   local self = System.requires {"Action"}

   function self:mouseClick(entity, x, y)
	  local action = entity:get "Action"
	  local board = world:getAllWith {"BoardTile"}
	  
	  for _, i in ipairs(action.info.target) do
		 local index = InGameWorld.coordToIndex(i.x, i.y)
		 local tile = board[index]
		 local collider = tile:get "SphereCollider"
		 local sprite = tile:get "Sprite"
		 local over = checkDotInSphere(x, y,
									   collider.x, collider.y,
									   collider.radius)

		 if over then
			local desTile = tile:get "BoardTile"
			local srcTile = board[action.info.from+1]:get "BoardTile"
			local temp = srcTile.entity:get "Sprite"
			
			desTile.faction = "Guarani"
			desTile.entity = srcTile.entity
			temp.x = sprite.x +18
			temp.y = sprite.y +9
			srcTile.faction = nil
		 end
		 sprite.color = {255, 255, 255}
	  end

	  entity:destroy()
	  world:unregister(self.__index)
   end
   function self:load(entity)
	  local action = entity:get "Action"
	  local board = world:getAllWith {"BoardTile"}

	  for _, i in ipairs(action.info.target) do
		 local index = InGameWorld.coordToIndex(i.x, i.y)
		 local sprite = board[index]:get "Sprite"
		 local boardTile = board[index]:get "BoardTile"
		 if boardTile.faction == nil then
			sprite.color = {0, 255, 255}
		 end
	  end
	  --[[
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
	  --]]
   end

   return self
end
function InGameAction.collectAction()
   local self = System.requires {"Action"}

   function self:load(entity)
	  local action = entity:get "Action"
	  local resource = world:getAllWith {"GameState"}[1]:get "Resource"
	  
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

	  for _,coord in ipairs(action.info.target) do
		 local temp = board[coord]:get "BoardTile"
		 local pawn = temp.entity:get "Pawn"
		 pawn.life = pawn.life -1
		 if pawn.life == 0 then
			temp.entity:destroy()
			temp.faction = nil
		 end
	  end
	  InGameWorld.needUpdate("Board")
	  
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
