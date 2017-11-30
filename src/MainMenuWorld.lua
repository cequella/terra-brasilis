require "ecs.World"

require "CommonEntities"
require "CommonSystems"

require "InGameWorld"

MainMenuWorld = {}
setmetatable(MainMenuWorld, {
				__index = MainMenuWorld,
				__call = function(instance)
				   local self = World()

				   self
					  :register( render() )
					  :register( squareHighlight() )
					  :register( showHelp() )

				   local startNewGame = function()
					  world = InGameWorld()
				   end
				   local bla = function()
					  print("Clicou")
				   end
				   local quit = function()
					  love.event.quit()
				   end

				   self:assemble( Background(cache.background) )
				   self:assemble( RectangleButton(cache.startButton, 0, 0*117, 208, 117, startNewGame) )
				   self:assemble( RectangleButton(cache.startButton, 0, 1*117, 208, 117, bla) )
				   self:assemble( RectangleButton(cache.startButton, 0, 2*117, 208, 117, bla) )
				   self:assemble( RectangleButton(cache.startButton, 0, 3*117, 208, 117, quit) )

				   self:register( MainMenuWorld.interation() )
				   
				   return self
				end
							}
)

function MainMenuWorld.interation()
   local self = System.requires {"ButtonCallback", "AABBCollider"}

   function self:mouseClick(entity, x, y, button)
	  if not VersionFlavour.isLeft(button) then return end

	  local collider = entity:get "AABBCollider"
      local over     = checkDotInRect(x,              y,
									  collider.x,     collider.y,
									  collider.width, collider.height)
	  if over then
		 local button = entity:get "ButtonCallback"
		 world:unregister(self)
		 button.callback()
      end

   end
   
   return self
end
