Component = require "ecs.Component"

function Sprite(image, x, y, width, height)
   local self = Component.new "Sprite"

   self.image = {}
   if type(image) ~= "table" then
	  self.image["Default"] = image
   else
	  self.image = image
   end
   self.state = "Default"

   self.x = x or 0
   self.y = y or 0
   self.width  = self.image["Default"]:getWidth()
   self.height = self.image["Default"]:getHeight()
   self.sx = 1.0
   self.sy = 1.0

   if width and height then
	  self.sx = width/self.width
	  self.sy = height/self.height
	  self.width  = width
	  self.height = height
   end
   return self
end

function Position(x, y)
   local self = Component.new "Position"

   self.x = x
   self.y = y
   
   return self
end

function MouseListener(callback)
   local self = Component.new "MouseListener"
   self.oldState = nil
   self.callback = callback
   self.over     = false
   return self
end

function SphereCollider(radius)
   local self = Component.new "SphereCollider"
   self.radius = radius
   return self
end

function CallActionMenu()
   local self = Component.new "CallActionMenu"
   self.menu = nil
   return self
end

function PieMenu(x, y)
   local self = Component.new "PieMenu"

   self.x = x
   self.y = y

   return self
end
