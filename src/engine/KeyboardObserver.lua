
KeyboardObserver = {}
KeyboardObserver.__index = KeyboardObverser

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
function KeyboardObserver:new()
   self.observable = {}
end
----------------------------------------------


-- methods


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

   for i, observable in ipairs(self.observable) do
	  observable:onKeyPressed(key, scancode, isrepeat)
   end
   
end
----------------------------------------------
