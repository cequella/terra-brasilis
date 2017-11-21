return {
   new = function()
      local Entity = {
	 componentList = {},
	 tagList = {},
	 childList = {},
	 remove = false,
	 loaded = false
      }

      function Entity:destroy()
	 for i=1, #self.childList do
	    self.childList[i]:destroy()
	 end
	 
	 self.remove = true
      end
      
      function Entity:add(component)
	 assert(component.__id)
	 self.componentList[component.__id] = component
	 self.tagList[component.__id] = true
	 return component
      end

      function Entity:addChild(entity)
	 self.childList[#self.childList] = entity
	 return entity
      end
      
      function Entity:get(id)
	 return self.componentList[id]
      end

      function Entity:getChild(id)
	 return self.childList[id]
      end
      
      function Entity:check(id)
	 return (self.tagList[id]==nil) and false or self.tagList[id]
      end

      function Entity:enable(id)
	 if self:get(id)~= nil then
	    self.tagList[id] = true
	 end
      end

      function Entity:disable(id)
	 if self:get(id)~= nil then
	    self.tagList[id] = false
	 end
      end
      
      return Entity
   end
}
