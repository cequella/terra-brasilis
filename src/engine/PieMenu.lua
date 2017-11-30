
PieMenu = {}
PieMenu.__index = PieMenu

-- metatable

setmetatable(PieMenu, {
		__call = function(instance, size, radius)
		   local self = setmetatable({}, instance)
		   instance:new(size)
		   return self
		end
		      }
)

--------------------------------------------------------------
function PieMenu:new(size, radius)
   self.size   = size or 50.0
   self.radius = radius or 50.0
   
   -- options
   self.visible  = false
   self.option   = {}
   self.current  = 0
   self.angle    = 0
   self.position = {x= 0, y=0}

   return self
end
--------------------------------------------------------------

-- Private

--------------------------------------------------------------
local function updateState(self)
   
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

   for i, option in ipairs(self.option) do
      local posx = self.position.x + self.radius*math.cos(i*self.angle)
      local posy = self.position.y + self.radius*math.sin(i*self.angle)

      love.graphics.setColor(255, 255, 255)
      love.graphics.circle("fill", posx, posy, self.size/2.0)
   end
end
--------------------------------------------------------------
