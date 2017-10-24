require "engine.MouseObserver"
require "engine.KeyboardObserver"
require "engine.Scene"

InGameScene = {}
InGameScene.__index = InGameScene

-- metatable

setmetatable(InGameScene, {
		__index = Scene,
		__call = function(instance)
		   local self = setmetatable({}, instance)
		   instance:new()
		   return self
		end
			    }
)

-- private

---------------------------------------------------------
local function drawTitle()
   love.graphics.setColor(255, 255, 255);
   love.graphics.rectangle("fill", 100, 0, love.window.getWidth()-200, 50)
end
---------------------------------------------------------

---------------------------------------------------------
local function drawClock(x, y, radius, angle)
   love.graphics.push()
   love.graphics.translate(x, y)
   love.graphics.rotate(angle)
   
   -- day
   love.graphics.setColor(180, 180, 180)
   love.graphics.push()
   love.graphics.arc("fill", 0, 0, radius, 0, math.pi)
   love.graphics.pop()

   -- night
   love.graphics.setColor(30, 30, 30)
   love.graphics.push()
   love.graphics.rotate(math.pi)
   love.graphics.arc("fill", 0, 0, radius, 0, math.pi)
   love.graphics.pop()
   
   love.graphics.pop()
end
---------------------------------------------------------

---------------------------------------------------------
local function angleUpdate(angle, update)
   local out = angle-update

   if out < 2.0*math.pi or out > 0.0 then
      return out
   else
      return out%(2.0*math.pi)
   end
end
---------------------------------------------------------

-- methods

---------------------------------------------------------
function InGameScene:new()
   Scene.new(self, "InGame")

   self.angle = 0.0;
end
---------------------------------------------------------

---------------------------------------------------------
function InGameScene:display()
   drawTitle()
   drawClock(love.window.getWidth()/2.0, 50.0, 100, self.angle)

   self.angle = angleUpdate(self.angle, 0.01);
end
---------------------------------------------------------
