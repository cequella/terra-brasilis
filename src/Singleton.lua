Singleton = {}
Singleton.__index = Singleton
setmetatable(Singleton, {
		__call = function(instance)
		   return Singleton.new(instance)
		end
			}
)

function Singleton.new(instance)
   local self = setmetatable({}, instance)

   self.TILE_SIZE           = 96
   self.PIEMENU_BUTTON_SIZE = 30
   self.PIEMENU_RADIUS      = 48
   self.PAW_SIZE            = 64

   -- Cognition
   self.feedback = 0.4 --seconds

   self.clock     = love.graphics.newImage("assets/SunAndMoon.png")
   self.card      = love.graphics.newImage("assets/card.jpg")
   self.tileImage = love.graphics.newImage("assets/tile.png")
   self.pieMenu = {
      spawn           = love.graphics.newImage("assets/tempButton.png"),
      move            = love.graphics.newImage("assets/tempButton.png"),
      attack          = love.graphics.newImage("assets/tempButton.png"),
      upgrade         = love.graphics.newImage("assets/tempButton.png"),
      craft           = love.graphics.newImage("assets/tempButton.png"),
      resourceCollect = love.graphics.newImage("assets/tempButton.png"),
   }
   self.pieMenuDisabled = love.graphics.newImage("assets/tempButtonU.png")
   self.guarani = love.graphics.newImage("assets/bart.png")
   self.resourceMarker = love.graphics.newImage("assets/card.jpg")

   self.winMessage  = love.graphics.newImage("assets/win.png")
   self.loseMessage = love.graphics.newImage("assets/lose.png")

   return self
end
