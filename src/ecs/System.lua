return {
   requires = function(dependence)
      assert(type(dependence) == "table")
      local System = {
	 dependence = dependence
      }

      function System:match(entity)
	 for i=1, #self.dependence do
	    local available = entity:check(self.dependence[i])
	    
	    if not available then return false end
	 end
	 return true
      end

	  function System:mouseClick(entity, x, y, button, isTouch)          end
      function System:mouseChanged(entity, x, y, state, button, isTouch) end
      function System:mouseMoved(entity, x, y, dx, dy, isTouch)          end
      function System:mouseWheel(entity, x, y)                           end
      function System:keyboardChanged(entity, key, state)                end
      
      function System:load(entity)       end
      function System:update(dt, entity) end
      function System:draw(entity)       end
      function System:destroy(entity)    end

      return System
   end
}
