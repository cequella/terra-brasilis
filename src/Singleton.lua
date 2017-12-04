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
      spawn           = love.graphics.newImage("assets/indioIcon.png"),
      move            = love.graphics.newImage("assets/andarIcon.png"),
      attack          = love.graphics.newImage("assets/atkIcon.png"),
      upgrade         = love.graphics.newImage("assets/tempButton.png"),
      craft           = love.graphics.newImage("assets/craftIcon.png"),
      resourceCollect = love.graphics.newImage("assets/explorarIconn.png"),
   }
   self.pieMenuDisabled = love.graphics.newImage("assets/tempButtonU.png")
   self.guarani = love.graphics.newImage("assets/bart.png")
   self.resourceMarker = love.graphics.newImage("assets/resourceTable.png")

   -- Buttons
   self.startButton    = love.graphics.newImage("assets/StartGameButton.png")
   self.tutorialButton = love.graphics.newImage("assets/TutorialButton.png")
   self.configButton   = love.graphics.newImage("assets/ConfigButton.png")
   self.audioButton    = love.graphics.newImage("assets/AudioOptionButton.png")
   self.videoButton    = love.graphics.newImage("assets/VideoOptionButton.png")
   self.quitButton     = love.graphics.newImage("assets/QuitButton.png")
   self.backButton     = love.graphics.newImage("assets/BackButton.png")
   self.acceptButton   = love.graphics.newImage("assets/AcceptButton.png")
   
   self.winMessage  = love.graphics.newImage("assets/win.png")
   self.loseMessage = love.graphics.newImage("assets/lose.png")

   self.background = love.graphics.newImage("assets/background2.jpg")
   self.menuBackground = love.graphics.newImage("assets/menuBG.png")

   self.nightSound = love.audio.newSource("assets/night.ogg")
   
   return self
end
