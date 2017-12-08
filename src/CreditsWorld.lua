require "ecs.World"

require "CommonEntities"
require "CommonSystems"

require "AudioConfigWorld"
require "VideoConfigWorld"

CreditsWorld = {}
setmetatable(CreditsWorld, {
		__index = CreditsWorld,
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


		   self:assemble( Prop(cache.menuBackground,
							   0, 0,
							   cache.menuBackground:getWidth(),
							   cache.menuBackground:getHeight()) )
		   self:assemble( Prop(cache.logo,
				       (800 -cache.logo:getWidth())/2,
				       50,
				       cache.logo:getWidth(),
				       cache.logo:getHeight()) )
		   self:assemble( Prop(cache.credits,
							   (800 -(cache.credits:getWidth()*0.5))/2,
							   50,
							   cache.credits:getWidth()*0.5,
							   cache.credits:getHeight()*0.5) )
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
