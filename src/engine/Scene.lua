
Scene = {}
Scene.__index = Scene

-- metatable
setmetatable(Scene, {
				__call = function(instance, name)
				   local self = setmetatable({}, instance)
				   instance:new(name)
				   return self
				end
					}
)
-------------------------------------------------


-- methods


function Scene:new(name)
   self.name = name
end
-------------------------------------------------
function Scene:display()

end
-------------------------------------------------
