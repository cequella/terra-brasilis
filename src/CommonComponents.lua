Component = require "ecs.Component"

function GameState()
   local self = Component.new "GameState"
   self.playerType = "Player"
   self.turnCounter = 0
   self.currentAdversity = {
	  name = "Chuva",
	  image = cache.rain,
	  description = "Whatever",
	  duration = 3
   }
   self.adversityList = {"Rain"}
   self.menuOpened = false
   self.menuAssembled = false
   self.ingameMenu = {}
   return self
end

function Action(choice, info)
   local self = Component.new "Action"
   self.choice = choice
   self.info = info
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

function Sound(content, state)
   local self = Component.new "Sound"
   self.content = content
   self.state = state
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
function BoardTile(coord, faction, entity)
   local self = Component.new "BoardTile"
   self.coord = coord
   self.faction = faction
   self.entity = entity
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

function AudioUI(x, y, width)
   local self = Component.new "AudioUI"
   self.position = { x=x, y=y }
   self.width    = width
   self.main     = { value=0.5, min=0.0, max=1.0 }
   self.effect   = { value=0.5, min=0.0, max=1.0 }
   return self
end

function VideoUI()
   local self = Component.new "VideoUI"
   return self
end

function Resource(time, mineral, vegetal, animal)
   local self = Component.new "Resource"
   self.time    = time
   self.mineral = mineral
   self.vegetal = vegetal
   self.animal  = animal
   return self
end

function Pawn()
   local self = Component.new "Pawn"
   self.life = 3
   self.over = false
   return self
end
