--require "MouseObserver"
--require "KeyboardObserver"

Scene = {}
Scene.__index = Scene

-- metatable
setmetatable(Scene, {
				__call = function(instance, name)
				   return instance.new(name)
				end
					}
)
-------------------------------------------------
function Scene.new(name)
   local self = setmetatable({}, Scene)

   self.name = name
   
   --self.keyboard = KeyboardObserver.new()
   --self.mouse    = MouseObverser.new()
   
   return self
end
-------------------------------------------------


-- methods


function Scene:display()

end
-------------------------------------------------
function Scene:quit()
   love.event.quit()
end
-------------------------------------------------
function Scene:notifyMouse(mode, x, y, button, istouch)
   --self.mouse:notify(mode, x, y, button, istouch)
end
-------------------------------------------------
function Scene:notifyKeyboard(mode, key, scancode, isrepeat)
   --self.keyboard:notify(mode, key, scancode, isrepeat)
end
-------------------------------------------------
