
MouseObserver = {}
MouseObserver.__index = MouseObserver

-- metatable
setmetatable(MouseObserver,{
		__call = function(instance)
		   local self = setmetatable({}, instance)
		   instance:new()
		   return self
		end
			   }
)
--------------------------------------------------------------


-- methods

function MouseObserver:new()
   self.observable = {}
end
--------------------------------------------------------------
function MouseObserver:attach(observable)

   self.observable[ #self.observable +1 ] = observable

end
--------------------------------------------------------------
function MouseObserver:detach(observable)

   for i=1, #self.observable do
      -- TODO
   end

end
--------------------------------------------------------------
function MouseObserver:notify(mode, x, y, button, istouch)

   for i=1, #self.observable do
      local current = self.observable[i]
      current:onClick(mode, x, y, button, istouch)
   end
   
end
--------------------------------------------------------------
