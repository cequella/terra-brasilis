System = {}
System.__index = System
setmetatable(System, {
				__call = function(instance)
				   local self = setmetatable({}, instance)
				   self.methodList = {}
				   return self
				end
					 }
)

------------------------------------------------------------------
function System:addMethod(method, dependence, ...)
   local arg = {...}

   local id = #self.methodList +1
   self.methodList[id] = {}
   self.methodList[id].method = method
   self.methodList[id].dependence = {}
   self.methodList[id].dependence[1] = dependence   
   
   if #arg > 0 then
	  for i=1, #arg do
		 self.methodList[id].dependence[i+1] = arg[i]
	  end	  
   end

   return self
end
------------------------------------------------------------------

------------------------------------------------------------------
function System:execute(world, id)
   local temp = self.methodList[id]

   local entityList = world:getEntities(unpack(temp.dependence))
   for i=1, #entityList do
	  local entity = entityList[i]
	  temp.method( entity:get(unpack(temp.dependence)) )
   end
end
------------------------------------------------------------------

------------------------------------------------------------------
function System:executeAll(world)
   for i=1, #self.methodList do
	  self:execute(world, i)
   end
end
------------------------------------------------------------------
