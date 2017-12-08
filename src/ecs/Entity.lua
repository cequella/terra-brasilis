return {
   new = function()
      local Entity = {
		 componentList = {},
		 tagList = {},
		 remove = false,
		 loaded = false
      }

      function Entity:destroy()
		 self.remove = true
      end
      
      function Entity:add(component)
		 assert(component.__id)
		 self.componentList[component.__id] = component
		 self.tagList[component.__id] = true
		 return component
      end

      function Entity:get(id)
		 return self.componentList[id]
      end

      function Entity:check(id)
		 return (self.tagList[id]==nil) and false or self.tagList[id]
      end
      
      return Entity
   end
}
