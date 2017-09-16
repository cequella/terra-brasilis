
Menu = {}
Menu.__index = Menu

-- metatable

setmetatable(Menu, {
				__call = function(instance, x, y)
				   return instance.new(x, y)
				end
				   }
)
--------------------------------------------------------------
function Menu.new(x, y)
   local self = setmetatable({}, Menu)

   -- coord
   self.x = x or 0
   self.y = y or 0
   self.w = 0
   self.h = 0

   -- font related
   self.font       = love.graphics.getFont()
   self.fontHeight = self.font:getHeight()

   -- options
   self.optionLabel = {}
   self.optionReact = {}
   self.current     = 0

   -- colors
   self.normalColor   = {255, 255, 255, 255}
   self.selectedColor = {255, 0,   0,   255}
   self.disabledColor = {0,   0,   0,   150}
   
   return self
end
--------------------------------------------------------------


-- methods


function Menu:addOption(label, reaction)
   local last = #self.optionLabel +1
   self.optionLabel[last] = label
   self.optionReact[last] = reaction

   -- get largest option to set as actually menu width
   local width = self.font:getWidth(label)
   if width > self.w then
	  self.w = width
   end

   -- update menu height
   self.h = self.h +self.fontHeight
end
--------------------------------------------------------------
function Menu:display()
   self:update()
   
   for i, label in ipairs(self.optionLabel) do

	  -- set option color
	  local color = nil
	  if i == self.current then
		 color = self.selectedColor
	  else
		 color = self.normalColor
	  end
	  love.graphics.setColor(color[1], color[2], color[3], color[4])

	  -- draw option
	  local height = (i-1)*self.fontHeight
	  love.graphics.print(label, self.x, self.y +height)
   end
end
--------------------------------------------------------------
function Menu:update()
   local mouseX = love.mouse.getX()
   local mouseY = love.mouse.getY()

   -- check if cursor isn't in the menu area
   self.current = 0
   if mouseX < self.x         then return end
   if mouseX > self.x +self.w then return end
   if mouseY < self.y         then return end
   if mouseY > self.y +self.h then return end

   -- if cursor is in menu area, get position
   self.current = math.ceil( (mouseY-self.y)/self.fontHeight )
end
--------------------------------------------------------------
function Menu:onClick(mode, x, y, button, istouch)  
   if button ~= 1 then return end
   if self.current == 0 then return end

   local reaction = self.optionReact[self.current]
   reaction()
end
--------------------------------------------------------------
