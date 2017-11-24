Component = require "ecs.Component"

function GameState()
   local self = Component.new "GameState"
   self.currentAdversity = nil
   self.clock  = 0
   self.boardDimen = {
	  x = 120,
	  y = 130,
	  width = 6,
	  height = 5,
	  xStep = cache.TILE_SIZE*0.875,
	  yStep = cache.TILE_SIZE*0.750
   }
   self.board = {}
   return self
end

function Sprite(image, x, y, width, height, startState)
   local self = Component.new "Sprite"

   self.image = image
   self.state = (state==nil) and "Default" or startState

   self.x = x or 0
   self.y = y or 0
   self.width  = self.image:getWidth()
   self.height = self.image:getHeight()
   self.sx = 1.0
   self.sy = 1.0
   self.color = {255, 255, 255}

   if width and height then
      self.sx = width/self.width
      self.sy = height/self.height
      self.width  = width
      self.height = height
   end
   return self
end

function SphereCollider(centerX, centerY, radius, color)
   local self = Component.new "SphereCollider"
   self.x = centerX
   self.y = centerY
   self.radius  = radius
   self.color   = color
   return self
end

function AABBCollider(x, y, width, height, color)
   local self = Component.new "AABBCollider"
   self.x = x
   self.y = y
   self.width   = width
   self.height  = height
   self.color   = color 
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

function UIHelp(message, position)
   local self = Component.new "UIHelp"
   self.message  = message
   self.position = position
   self.timeOver = 0
   return self
end

function ResourceCollect()
   local self = Component.new "ResourceCollect"
   self.category = {"Herb", "Herb", "Herb"}
   return self
end
