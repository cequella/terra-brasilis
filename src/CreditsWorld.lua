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

		   local factor = 0.56
		   local topMargin = 400

		   local function hCenter(image)
		      return (800 -image:getWidth()*factor)/2
		   end

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
		   self:assemble( Prop(cache.credits,
				       (800 -(cache.credits:getWidth()*0.56))/2,
				       0,
				       cache.credits:getWidth()*0.56,
				       cache.credits:getHeight()*0.56) )
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
