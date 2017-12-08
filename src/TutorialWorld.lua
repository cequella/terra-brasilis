require "ecs.World"

require "CommonEntities"
require "CommonSystems"

require "AudioConfigWorld"
require "VideoConfigWorld"

TutorialWorld = {}
setmetatable(TutorialWorld, {
		__index = TutorialWorld,
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

		   local factor = 0.8
		   local topMargin = 400

		   local function hCenter(image)
		      return (800 -image:getWidth()*factor)/2
		   end

		   local factor = 0.56

		   --[[
		   self:assemble( Prop(cache.menuBackground,
				       0, 0,
				       cache.menuBackground:getWidth(),
				       cache.menuBackground:getHeight()) )
		   self:assemble( Prop(cache.logo,
				       (800 -cache.logo:getWidth())/2,
				       50,
				       cache.logo:getWidth(),
				       cache.logo:getHeight()) )
		   --]]
		   self:assemble( Prop(cache.tutorial,
				       (800 -(cache.tutorial:getWidth()*factor))/2,
				       0,
				       cache.tutorial:getWidth()*factor,
				       cache.tutorial:getHeight()*factor) )
		   self:assemble( RectangleButton(cache.backButton,
						  hCenter(cache.backButton),
						  topMargin +140,
						  cache.backButton:getWidth() *0.8,
						  cache.backButton:getHeight() *0.8,
						  backToMainMenu) )
		   --self:assemble( BackgroundSound(cache.nightSound, "Play") )
		   
		   return self
		end
			    }
)
