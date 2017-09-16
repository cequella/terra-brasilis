
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
   self.option  = {}
   self.current = 0

   -- colors
   self.color = { normal   ={255, 255, 255, 255},
				  deactive ={0,   0,   0,   150},
				  selected ={255, 0,   0,   255}}
   
   return self
end
--------------------------------------------------------------


-- methods


function Menu:addOption(label, reaction, active)
   local last = #self.option +1

   self.option[last] = {label  = label,
						react  = reaction,
						active = active == nil or active}

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
   
   for i, option in ipairs(self.option) do

	  -- set option color
	  local color = nil

	  if self.option[i].active then
		 color = self.current == i and self.color.selected or self.color.normal
	  else
		 color = self.color.deactive
	  end
	  love.graphics.setColor(color[1], color[2], color[3], color[4])

	  -- draw option
	  local height = (i-1)*self.fontHeight
	  love.graphics.print(option.label, self.x, self.y +height)
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

   local reaction = self.option[self.current].react
   reaction()
end
--------------------------------------------------------------
