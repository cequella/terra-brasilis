Component = require "ecs.Component"

function Sprite(image, x, y, width, height, state)
   local self = Component.new "Sprite"

   self.image = {}
   if type(image) ~= "table" then
      self.image["Default"] = image
   else
      self.image = image
   end
   self.state = (state==nil) and "Default" or state

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

function MouseListener(callback)
   local self = Component.new "MouseListener"
   self.oldState = nil
   self.over     = false
   return self
end

function SphereCollider(centerX, centerY, radius)
   local self = Component.new "SphereCollider"
   self.x = centerX
   self.y = centerY
   self.radius  = radius
   return self
end

function ButtonCallback(callback)
   local self = Component.new "ButtonCallback"
   self.callback = callback
   return self
end
function BoardTile()
   local self = Component.new "BoardTile"
   self.content = nil
   return self
end

function Spawn()
   local self = Component.new "Spawn"
   return self
end

function Resource()
   local self = Component.new "Resource"
   return self
end

function Player()
   local self = Component.new "Player"
   self.faction = "Guarani"
   return self
end

function UIHelp(message, position)
   local self = Component.new "UIHelp"
   self.message  = message
   self.position = position
   self.timeOver = 0
   return self
end
