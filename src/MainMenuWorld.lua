require "ecs.World"

require "CommonEntities"
require "CommonSystems"

require "InGameWorld"
require "ConfigWorld"

MainMenuWorld = {}
setmetatable(MainMenuWorld, {
				__index = MainMenuWorld,
				__call = function(instance)
				   local self = World()

				   self
					  :register( render() )
					  :register( squareHighlight() )
					  :register( playSound() )
					  :register( rectButtonCallbackExecute() )

				   local startNewGame = function()
					  world = InGameWorld()
				   end
				   local openConfigMenu = function()
					  world = ConfigWorld()
				   end
				   local bla = function()
					  print("Clicou")
				   end
				   local quit = function()
					  love.event.quit()
				   end

				   local factor    = 0.8
				   local topMargin = 280

				   local function hCenter(image)
					  return (800 -image:getWidth()*factor)/2
				   end
				   
				   self:assemble( Background(cache.menuBackground) )
				   self:assemble( RectangleButton(cache.startButton,
												  hCenter(cache.startButton),
												  topMargin,
												  cache.startButton:getWidth() *factor,
												  cache.startButton:getHeight() *factor,
												  startNewGame) )
				   self:assemble( RectangleButton(cache.tutorialButton,
												  hCenter(cache.tutorialButton),
												  topMargin+90,
												  cache.tutorialButton:getWidth() *factor,
												  cache.tutorialButton:getHeight() *factor,
												  bla) )
				   self:assemble( RectangleButton(cache.configButton,
												  hCenter(cache.configButton),
												  topMargin+170,
												  cache.configButton:getWidth() *factor,
												  cache.configButton:getHeight() *factor,
												  openConfigMenu) )
				   self:assemble( RectangleButton(cache.quitButton,
												  hCenter(cache.quitButton),
												  topMargin+240,
												  cache.quitButton:getWidth() *factor,
												  cache.quitButton:getHeight() *factor,
												  quit) )
				   --self:assemble( BackgroundSound(cache.nightSound, "Play") )
				   
				   return self
				end
							}
)
