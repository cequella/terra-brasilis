require "ecs.World"

require "CommonSystems"
require "CommonEntities"

InGameWorld = {}
setmetatable(InGameWorld,{
				__index = InGameWorld,
				__call = function(instance)
				   local self = World()

				   self
					  :register( render() )
					  :register( gameUI() )
					  :register( roundHighlight() )
					  :register( squareHighlight() )
					  :register( tilePieMenu() )
					  :register( showHelp() )
					  :assemble( Game() )

				   return self
				end
						 }
)
