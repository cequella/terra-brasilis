
PieMenu = {}
PieMenu.__index = PieMenu

-- metatable

setmetatable(PieMenu, {
		__call = function(instance, size)
		   local self = setmetatable({}, instance)
		   instance:new(size)
		   return self
		end
		      }
)

--------------------------------------------------------------
function PieMenu:new(size)
   self.size = size or 50.0

   -- options
   self.visible  = false
   self.option   = {}
   self.current  = 0
   self.angle    = 0
   self.position = {x= 0, y=0}

   return self
end
--------------------------------------------------------------

-- Methods

--------------------------------------------------------------
function PieMenu:addOption(icon, label, reaction, active)
   local last = #self.option +1

   self.option[last] = {icon   = icon,
			label  = label,
			react  = reaction,
			active = active == nil or active}

   self.angle = 2*math.pi/last
   return self
end
--------------------------------------------------------------

--------------------------------------------------------------
function PieMenu:display() -- temp, try again
   if not self.visible then return end -- avoid display

   love.graphics.setColor(255, 255, 255)
   for i, option in ipairs(self.option) do
      love.graphics.push()
      love.graphics.translate(self.position.x, self.position.y)
      love.graphics.rotate(i*self.angle)
      love.graphics.circle("fill", 0, self.size, self.size/2.0)
      love.graphics.pop()
   end
end
--------------------------------------------------------------
