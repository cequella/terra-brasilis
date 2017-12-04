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

		   self:assemble( Prop(cache.background, 0, 0, cache.background:getWidth(), cache.background:getHeight()) )
		   self:assemble( Game() )

		   return self
		end
			 }
)
