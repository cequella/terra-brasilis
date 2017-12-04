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
		      :register( InGameWorld.ui() )
		      :register( roundHighlight() )
		      :register( squareHighlight() )
		      :register( rectButtonCallbackExecute() )
		      --:register( tilePieMenu() )
		      :register( showHelp() )

		   local function bla()
		      print "Ola"
		      self:register( InGameWorld.cardDescription() )
		   end

		   self:assemble( Prop(cache.background, 0, 0, cache.background:getWidth(), cache.background:getHeight()) )
		   local xStep = cache.TILE_SIZE*0.875
		   local yStep = cache.TILE_SIZE*0.750
		   for i=0, 5 do
		      for j=0, 5 do
			 local posX = (i%2==0) and 120 +j*xStep or 120 +xStep*(j+0.5)
			 local posY = 135 +i*yStep
			 self:assemble( Tile(cache.tileImage, posX, posY) )
		      end
		   end
		   self:assemble( WorldClock() )
		   self:assemble( Prop(cache.frame, 0, 0, cache.frame:getWidth(), cache.frame:getHeight()) )
		   self:assemble( RectangleButton(cache.rain,
						  200, 0,
						  cache.rain:getWidth()*0.15, cache.rain:getHeight()*0.15,
						  bla, "Adversidade Ativa", "AtBottom") )
		   self:assemble( Game() )

		   return self
		end
			 }
)

function InGameWorld.ui()
   local self = System.requires {"GameState"}

   function self:drawUI(entity)
      local state = entity:get "GameState"

      local tempFont = love.graphics.getFont();
      local topMargin = 510
      
      love.graphics.setFont(cache.uiFont)
      for i=1, 3 do
	 love.graphics.print(tostring(state.resource[i]), 60, topMargin +22*(i-1))
      end
      love.graphics.setFont(tempFont)
   end

   return self
end

function InGameWorld.cardDescription()
   local self = System.requires {"GameState"}

   function self:draw(entity)
      local state = entity:get "GameState"

      -- background
      love.graphics.setColor(0, 0, 0, 200)
      love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
      love.graphics.setColor(255, 255, 255)
      
      local card = state.currentAdversity
      love.graphics.draw(card, 50, (love.graphics.getHeight()-card:getHeight())/2)
   end
   
   return self
end
