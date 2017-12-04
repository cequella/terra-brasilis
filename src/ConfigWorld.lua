require "ecs.World"

require "CommonEntities"
require "CommonSystems"

require "AudioConfigWorld"
require "VideoConfigWorld"

ConfigWorld = {}
setmetatable(ConfigWorld, {
		__index = ConfigWorld,
		__call = function(instance)
		   local self = World()

		   self
		      :register( render() )
		      :register( squareHighlight() )
		      :register( playSound() )
		      :register( rectButtonCallbackExecute() )

		   local backToMainMenu = function()
		      world = MainMenuWorld()
		   end
		   local openAudioMenu = function()
		      world = AudioConfigWorld()
		   end
		   local openVideoMenu = function()
		      world = VideoConfigWorld()
		   end

		   local factor = 0.8
		   local topMargin = 400

		   local function hCenter(image)
		      return (800 -image:getWidth()*factor)/2
		   end


		   self:assemble( Prop(cache.menuBackground, 0, 0, cache.menuBackground:getWidth(), cache.menuBackground:getHeight()) )
		   self:assemble( Prop(cache.logo,
				       (800 -cache.logo:getWidth())/2,
				       50,
				       cache.logo:getWidth(),
				       cache.logo:getHeight()) )
		   self:assemble( RectangleButton(cache.audioButton,
						  hCenter(cache.audioButton),
						  topMargin,
						  cache.audioButton:getWidth() *factor,
						  cache.audioButton:getHeight() *factor,
						  openAudioMenu) )
		   self:assemble( RectangleButton(cache.videoButton,
						  hCenter(cache.videoButton),
						  topMargin +70,
						  cache.videoButton:getWidth() *factor,
						  cache.videoButton:getHeight() *factor,
						  openVideoMenu) )
		   self:assemble( RectangleButton(cache.backButton,
						  hCenter(cache.backButton),
						  topMargin +140,
						  cache.backButton:getWidth() *factor,
						  cache.backButton:getHeight() *factor,
						  backToMainMenu) )
		   --self:assemble( BackgroundSound(cache.nightSound, "Play") )
		   
		   return self
		end
			  }
)
