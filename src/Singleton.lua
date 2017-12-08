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
   self.PAWN_SIZE           = 64

   -- Cognition
   self.feedback = 0.4 --seconds

   self.clock     = love.graphics.newImage("assets/SunAndMoon.png")
   self.card      = love.graphics.newImage("assets/card.jpg")
   self.tileImage = love.graphics.newImage("assets/tile.png")
   self.pieMenu = {
      spawn           = love.graphics.newImage("assets/nativeIcon.png"),
      move            = love.graphics.newImage("assets/moveIcon.png"),
      attack          = love.graphics.newImage("assets/atkIcon.png"),
      upgrade         = love.graphics.newImage("assets/upgradeIcon.png"),
      craft           = love.graphics.newImage("assets/craftIcon.png"),
      resourceCollect = love.graphics.newImage("assets/collectIcon.png"),
   }
   self.pieMenuDisabled = love.graphics.newImage("assets/unabledButton.png")
   self.guarani = love.graphics.newImage("assets/bart.png")
   self.resourceMarker = love.graphics.newImage("assets/resourceTable.png")
   self.logo = love.graphics.newImage("assets/logo.png")
   self.frame = love.graphics.newImage("assets/InGameFrame.png")

   -- Buttons
   self.startButton    = love.graphics.newImage("assets/StartGameButton.png")
   self.tutorialButton = love.graphics.newImage("assets/TutorialButton.png")
   self.configButton   = love.graphics.newImage("assets/ConfigButton.png")
   self.audioButton    = love.graphics.newImage("assets/AudioOptionButton.png")
   self.videoButton    = love.graphics.newImage("assets/VideoOptionButton.png")
   self.quitButton     = love.graphics.newImage("assets/QuitButton.png")
   self.backButton     = love.graphics.newImage("assets/BackButton.png")
   self.acceptButton   = love.graphics.newImage("assets/AcceptButton.png")
   self.closeButton    = love.graphics.newImage("assets/XButton.png")

   self.lifeIcon = love.graphics.newImage("assets/lifeIcon.png")
   
   self.winMessage  = love.graphics.newImage("assets/win.png")
   self.loseMessage = love.graphics.newImage("assets/lose.png")

   self.background = love.graphics.newImage("assets/background2.jpg")
   self.menuBackground = love.graphics.newImage("assets/menuBG.png")

   -- Sounds
   self.nightSound     = love.audio.newSource("assets/night.ogg")
   self.buttonFeedback = love.audio.newSource("assets/buttonFeedback.mp3")
   self.buttonFeedback:setVolume(0.0)

   -- Font
   self.uiFont = love.graphics.newFont("assets/CoolinCheer.ttf", 22)

   -- Adversity Cards
   self.rain = love.graphics.newImage("assets/rainAdv.png")

   return self
end
