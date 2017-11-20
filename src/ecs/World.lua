require "utils.Utils"

local Entity = require "ecs.Entity"

local World = {
   entityList = {},
   systemList = {}
}

function World:register(system)
   table.insert(self.systemList, system)
   return self
end

function World:unregister(system)
   for i=1, #self.systemList do
	  if system == self.systemList[i] then
		 table.remove(self.systemList, i)
	  end
   end
   return self
end

function World:getAllWith(requires)
   local match = {}

   for i=1, #self.entityList do
	  local entity = self.entityList[i]
	  local matches = true
	  for j=1, #requires do
		 if entity:get(requires[i]) == nil then
			matches = false
			break
		 end
	  end

	  if matches then
		 table.insert(match, entity)
	  end
   end
   
   return match
end

function World:assemble(components)
   local ent = self:create()
   
   for i, v in ipairs(components) do
	  assert( type(v)=="table", "components must be a table of table")

	  if #v > 0 then
		 local fn = v[1]
		 assert( type(fn)=="function", "first element must be a function" )

		 if #v == 1 then
			ent:add(fn())
		 else
			local args = {}
			for j=2, #v do
			   table.insert(args, v[j])
			end

			ent:add( fn(unpack(args)) )
		 end
	  end
   end

   return ent
end

function World:multiAssemble(components)
   assert( type(components)=="table" )
   
   local ent = self:create()
   for i=1, #components do
	  ent.childList[i] = self:assemble(components[i])
   end

   return ent
end

function World:create()
   local entity = Entity.new()
   table.insert( self.entityList, entity )
   return entity
end

function World:update(dt)
   for i=#self.entityList, 1, -1 do
	  local entity = self.entityList[i]
	  if entity.remove then
		 
		 for _, system in ipairs(self.systemList) do
			if system:match(entity) then
			   system:destroy(entity)
			end
		 end
		 table.remove(self.entityList, i)

	  else
		 
		 for _, system in ipairs(self.systemList) do
			if system:match(entity) then
			   if not entity.loaded then
				  system:load(entity)
			   end
			   system:update(dt, entity)
			end
		 end
		 entity.loaded = true
		 
	  end
   end
end
function World:draw()
   for i=1, #self.entityList do
	  local entity = self.entityList[i]
	  
	  for _, system in ipairs(self.systemList) do
		 if system:match(entity) then
			if entity.loaded then
			   system:draw(entity)
			else
			   system:load(entity)
			   --entity.loaded = true --I don't know why
			end
		 end
	  end
   end
end

return World
