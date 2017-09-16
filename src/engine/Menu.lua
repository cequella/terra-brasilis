
Menu = {}
Menu.__index = Menu

-- metatable

setmetatable(Menu, {
				__call = function(instance, x, y, font, fontSize)
				   local self = setmetatable({}, instance)
				   instance:new(x, y, font)
				   return self
				end
				   }
)
--------------------------------------------------------------
function Menu:new(x, y, font)
   -- coord
   self.x = x or 0
   self.y = y or 0
   self.w = 0

   -- font related
   self.font = nil
   self:setFont(font)

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

--private
local function update(self)
   local mouseX = love.mouse.getX()
   local mouseY = love.mouse.getY()

   local height = #self.option *self.font:getHeight()
   -- check if cursor isn't in the menu area
   if mouseX < self.x         then return end
   if mouseX > self.x +height then return end
   if mouseY < self.y         then return end
   if mouseY > self.y +height then return end

   -- if cursor is in menu area, get position
   self.current = math.ceil( (mouseY-self.y)/self.font:getHeight() )
end
--------------------------------------------------------------


-- methods

function Menu:setFont(font)
   self.font = font or love.graphics.getFont()
   return self
end
--------------------------------------------------------------
function Menu:normalColor(r, g, b, a)
   self.color.normal = {r, g, b, a or 255}

   return self
end
--------------------------------------------------------------
function Menu:selectedColor(r, g, b, a)
   self.color.selected = {r, g, b, a or 255}

   return self
end
--------------------------------------------------------------
function Menu:deactiveColor(r, g, b, a)
   self.color.deactive = {r, g, b, a or 255}

   return self
end
--------------------------------------------------------------
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

   return self
end
--------------------------------------------------------------
function Menu:display()
   update(self)

   love.graphics.setFont(self.font)
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
	  local height = (i-1)*self.font:getHeight()
	  love.graphics.print(option.label, self.x, self.y +height)
   end
end
--------------------------------------------------------------
function Menu:onClick(mode, x, y, button, istouch)  
   if button ~= 1 then return end
   if self.current == 0 then return end

   local reaction = self.option[self.current].react
   reaction()
end
--------------------------------------------------------------
function Menu:onKeyPressed(mode, key, scancode, isrepeat)

   if key == "down" and self.current < #self.option then
	  self.current = self.current +1

   elseif key == "up" and self.current > 1 then
	  self.current = self.current -1
	  
   elseif key == "return" and self.current > 0 then
	  local reaction = self.option[self.current].react
	  reaction()
	  
   end
end
--------------------------------------------------------------
