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
		      :register( roundHighlight() )
		      :register( squareHighlight() )
		      :register( rectButtonCallbackExecute() )
		      :register( roundButtonCallbackExecute() )
		      :register( showHelp() )
		      :register( InGameWorld.drawResource() )
		      :register( InGameWorld.innerMenu() )

		   self:assemble( Prop(cache.background,
				       0, 0,
				       cache.background:getWidth(), cache.background:getHeight()) )
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
						  cardDetail, "Adversidade ativa", "AtBottom") )
		   self:assemble( Game() )

		   return self
		end
			 }
)
function InGameWorld.drawResource()
   local self = System.requires {"GameState", "Resource"}
   
   function self:drawUI(entity)
      local resource = entity:get "Resource"

      local tempFont = love.graphics.getFont();
      local topMargin = 510
      
      love.graphics.setFont(cache.uiFont)
      love.graphics.print(tostring(resource.mineral), 60, topMargin)
      love.graphics.print(tostring(resource.vegetal), 60, topMargin+22)
      love.graphics.print(tostring(resource.animal),  60, topMargin+44)
      love.graphics.setFont(tempFont)
   end

   return self
end
function InGameWorld.enableInteraction()
   world
      :register( roundHighlight() )
      :register( callPieMenu() )
end
function InGameWorld.disableInteraction()
   world
      :unregister( "roundHighlight" )
      :unregister( "callPieMenu" )
end
function InGameWorld.innerMenu()
   local self = System.requires {"GameState"}

   function self:keyboardChanged(entity, key)
      local state = entity:get "GameState"

      if not state.menuIsOpened then
	 if key == "escape"  then
	    state.menuOpened = true
	 end
      end
   end
   function self:update(entity)
      local state = entity:get "GameState"
      if state.menuOpened and not state.menuAssembled then
	 InGameWorld.disableInteraction()
	 InGameWorld.createInnerMenu(state)
      end
   end
   function self:draw(entity)
      local state = entity:get "GameState"
      
      -- Show Menu
      if state.menuOpened then
	 love.graphics.setColor(0, 0, 0, 200)
	 love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	 love.graphics.setColor(255, 255, 255)
      end
   end

   return self
end
