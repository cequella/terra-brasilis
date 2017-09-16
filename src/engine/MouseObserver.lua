
MouseObserver = {}
MouseObserver.__index = MouseObserver

-- metatable
setmetatable(MouseObserver,{
				__call = function(instance)
				   return instance.new()
				end
						   }
)
--------------------------------------------------------------
function MouseObserver.new()
   local self = setmetatable({}, MouseObserver)

   self.observable = {}
   
   return self
end
--------------------------------------------------------------


-- methods


function MouseObserver:attach(reaction)

   self.observable[ #self.observable +1 ] = reaction

end
--------------------------------------------------------------
function MouseObserver:detach(reaction)

   for i=1, #self.observable do

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
