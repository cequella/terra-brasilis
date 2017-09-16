
KeyboardObserver = {}
KeyboardObserver.__index = KeyboardObserver

-- metatable
setmetatable(KeyboardObserver, {
				__call = function(instance)
				   local self = setmetatable({}, instance)
				   instance:new()
				   return self
				end
							   }
)
----------------------------------------------


-- methods


function KeyboardObserver:new()
   self.observable = {}
end
----------------------------------------------
function KeyboardObserver:attach(observable)
   self.observable[ #self.observable +1 ] = observable
end
----------------------------------------------
function KeyboardObserver:detach(observable)

   for i=1, #self.observable do
	  -- TODO
   end

end
----------------------------------------------
function KeyboardObserver:notify(mode, key, scancode, isrepeat)

   --[[
	  for i, observable in ipairs(self.observable) do
	  observable:onKeyPressed(key, scancode, isrepeat)
	  end
   --]]

   for i=1, #self.observable do
	  local current = self.observable[i]
	  current:onKeyPressed(mode, key, scancode, isrepeat)
   end
   
end
----------------------------------------------
