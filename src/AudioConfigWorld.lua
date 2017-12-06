require "ecs.World"

require "CommonEntities"
require "CommonSystems"

AudioConfigWorld = {}
setmetatable(AudioConfigWorld, {
		__index = AudioConfigWorld,
		__call = function(instance)
		   local self = World()

		   self
		      :register( render() )
		      :register( squareHighlight() )
		      :register( playSound() )
		      :register( rectButtonCallbackExecute() )
		      :register( showAudioConfig() )

		   local backToConfigMenu = function()
		      world = ConfigWorld()
		   end
		   local bla = function()
		      print("Clicou")
		   end
		   --[[
		      local quit = function()
		      love.event.quit()
		      end
		   --]]

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
		   self:assemble( RectangleButton(cache.acceptButton,
						  hCenter(cache.acceptButton),
						  topMargin,
						  cache.acceptButton:getWidth() *factor,
						  cache.acceptButton:getHeight() *factor,
						  bla) )
		   self:assemble( RectangleButton(cache.backButton,
						  hCenter(cache.backButton),
						  topMargin +70,
						  cache.backButton:getWidth() *factor,
						  cache.backButton:getHeight() *factor,
						  backToConfigMenu) )
		   self:assemble( BackgroundSound(cache.nightSound, "Play") )
		   self:assemble( AudioConfig((800 -200)/2, 250, 200) )
		   
		   return self
		end
			       }
)
