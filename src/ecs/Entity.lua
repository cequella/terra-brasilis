Entity = {}
Entity.__index = Entity
setmetatable(Entity, {
				__call = function(instance, world)
				   local self = setmetatable({}, instance)
				   
				   self.__id          = World.genEntityId(world)
				   self.tagList       = {}
				   self.componentList = {}
				   
				   return self
				end
					}
)

------------------------------------------------------------------
function Entity:addComponent(componentTag, component)
   self.tagList[componentTag]       = true
   self.componentList[componentTag] = component
   return self
end
------------------------------------------------------------------

------------------------------------------------------------------
function Entity:has(componentTag, ...)

   local arg = {...}
   
   if #arg == 0 then
	  local out = self.tagList[componentTag]
	  return (out and true or false) --force nil to return false
   else
	  local check = self.tagList[componentTag]
	  if not check then
		 return false
	  end
	  
	  for i=1, #arg do
		 check = self.tagList[arg[i]]
		 if not check then
			return false
		 end
	  end

	  return true
   end
end
------------------------------------------------------------------

------------------------------------------------------------------
function Entity:get(componentTag, ...)

   local arg = {...}

   if #arg == 0 then
	  return self.componentList[componentTag]
   else
	  local out = {}

	  out[1] = self.componentList[componentTag]
	  for i=1, #arg do
		 out[i+1] = self.componentList[arg[i]]
	  end

	  return unpack(out)
   end
end
------------------------------------------------------------------

------------------------------------------------------------------
function Entity:enable(componentTag, ...)
   local arg = {...}

   self.tagList[componentTag] = true

   if #arg > 0 then
	  for i=1, #arg do
		 self.tagList[arg[i]] = true
	  end
   end

   return self
end
------------------------------------------------------------------

------------------------------------------------------------------
function Entity:disable(componentTag, ...)
   local arg = {...}

   self.tagList[componentTag] = false

   if #arg > 0 then
	  for i=1, #arg do
		 self.tagList[arg[i]] = false
	  end
   end

   return self
end
------------------------------------------------------------------
