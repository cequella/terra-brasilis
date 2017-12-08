InGameAction = {}

function InGameAction.spawnDevil()
   local self = System.requires {"Action"}

   function self:load(entity)
      local action = entity:get "Action"
      local board = world:getAllWith {"BoardTile"}

      for _,i in ipairs(action.info) do
	 local tile = board[i]:get "BoardTile"
	 local sprite = board[i]:get "Sprite"

	 -- Spawn a new Bandeirante
	 if tile.faction == nil then
	    tile.faction = "Bandeirante"
	    tile.entity = world:assemble( Bandeirante(sprite.x +18, sprite.y+9) )
	 else 

	    local temp = board[i+6]:get "BoardTile"
	    while temp.faction == "Bandeirante" do
	       i = i+6
	       temp = board[i+6]:get "BoardTile"
	    end
	    
	    -- If the place behind is empty, move
	    if temp.faction == nil then
	       temp.faction = "Bandeirante"
	       temp.entity = tile.entity

	       local aux = temp.entity:get "Sprite"
	       local aux2 = board[i+6]:get "Sprite"
	       aux.x = aux2.x +18
	       aux.y = aux2.y +9
	       tile.faction = nil

	       -- If the space behind has a Guarani, kill it
	    elseif temp.faction == "Guarani" then
	       local pawn = temp.entity:get "Pawn"
	       pawn.life = pawn.life -1

	       if pawn.life == 0 then
		  temp.faction = nil
		  temp.entity:destroy()
	       end
	    elseif temp.faction == "Oca" then
	       print("PERDEU")
	    end
	 end
      end

      entity:destroy()
      world:unregister(self.__index)
   end

   return self
end

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
      InGameWorld.updateTurn(action.info.cost)
      
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

      --if action.info.target == nil then return end
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
	    InGameWorld.updateTurn(action.info.cost)
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
	    sprite.color = {0, 180, 255}
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

      InGameWorld.updateTurn(action.info.cost)
      
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
      InGameWorld.updateTurn(action.info.cost)
      
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
      InGameWorld.updateTurn(action.info.cost)
      
      entity:destroy()
      world:unregister(self.__index)
   end

   return self
end
