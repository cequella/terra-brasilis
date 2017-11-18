World = {}
World.__index = World
setmetatable(World, {
				__call = function(instance)
				   local self = setmetatable({}, instance)
				   self.entityList = {}
				   return self
				end
					}
)

------------------------------------------------------------------
function World.genEntityId(self)
   local id = #self.entityList +1
   self.entityList[id] = {}
   return id
end
------------------------------------------------------------------

------------------------------------------------------------------
function World:addEntity(entity)
   self.entityList[entity.__id] = entity
end
------------------------------------------------------------------

------------------------------------------------------------------
function World:getEntities(componentTag, ...)

   local arg = {...}
   local out = {}

   for i=1, #self.entityList do
	  local entity = self.entityList[i]

	  if entity:has(componentTag, unpack(arg)) then
		 out[#out +1] = entity
	  end
   end

   return out
end
------------------------------------------------------------------
