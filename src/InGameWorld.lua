require "ecs.World"

require "CommonSystems"
require "CommonEntities"

require "InGameMenus"

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
		      :register( playSound() )
		      :register( InGame.innerMenu() )
		      :register( InGameWorld.drawPawnStatus() )
		      :register( InGameWorld.drawResourcesMarker() )
		      :register( InGameWorld.playerGameflow() )

		   self:assemble( Game() )

		   return self
		end
			 }
)
function InGameWorld.pcGameflow()
   local self = System.requires {"GameState"}

   function self:update(entity, dt)
      local state = entity:get "GameState"

      --print(tostring(state.dt))
      
      if state.dt == nil then
	 state.dt = dt
	 return
      end
      state.dt = state.dt +dt

      local temp = {}
      for i=1, 3 do
	 table.insert(temp, math.random(1, 6))
      end
      
      world:register( InGameAction.spawnDevil() )
      world:assemble( DevilAction(temp) )

      state.dt = nil
      world
	 :unregister(self.__index)
	 :register( InGameWorld.playerGameflow() )
	 :register( InGame.callPieMenu() )
   end
   return self
end
function InGameWorld.playerGameflow()
   local self = System.requires {"GameState"}

   function self:keyboardChanged(entity, key)
      if key == "q" then
	 world
	    :unregister( "callPieMenu" )
	    :unregister( "showVictoryScreen" )
	    :register( InGameWorld.showLoseScreen() )
      elseif key == "w" then
	 world
	    :unregister( "callPieMenu" )
	    :unregister( "showLoseScreen" )
	    :register( InGameWorld.showVictoryScreen() )
      elseif key == "e" then
	 world
	    :unregister( "showLoseScreen" )
	    :unregister( "showVictoryScreen" )
	    :register( InGame.callPieMenu() )
      end
   end
   function self:load(entity)
      local game = entity:get "GameState"

      world
	 :register( InGame.callPieMenu() )
      
      -- Background
      world:assemble( Prop(cache.background,
			   0, 0,
			   cache.background:getWidth(), cache.background:getHeight()) )

      -- Board
      local xStep = cache.TILE_SIZE*0.875
      local yStep = cache.TILE_SIZE*0.750   
      local hSize = cache.TILE_SIZE/2
      local oca = {}
      for i=0, 5 do
	 for j=0, 5 do
	    local temp
	    
	    local coord = i*6+j
	    local posX = (i%2==0) and 120 +j*xStep or 120 +xStep*(j+0.5)
	    local posY = 135 +i*yStep
	    
	    local faction = nil
	    if coord==27 then
	       oca={x=posX, y=posY}
	       faction="Oca"
	       temp = cache.oca
	    else
	       temp = cache.tileImage
	    end
	    local tile = world:assemble( Tile(temp, posX, posY, coord, faction) )
	 end
      end

      -- Clock
      world:assemble( WorldClock() )

      -- Adversity
      world:assemble( RectangleButton(game.currentAdversity.image,
				      80, -3,
				      game.currentAdversity.image:getWidth()*0.32,
				      game.currentAdversity.image:getHeight()*0.32,
				      function() end,
				      game.currentAdversity.name, "AtBottom") )

      -- HUD
      world:assemble( Prop(cache.frame, 0, 0, cache.frame:getWidth(), cache.frame:getHeight()) )
      world:assemble( BackgroundSound(cache.daySound, "Play") )

      -- Gambs
      love.audio.stop(cache.menuSound)
   end
   function self:update(entity, dt)
      local state = entity:get "GameState"
      
      if state.needUpdate then
	 state.needUpdate = false
      end
      
      if state.turnCount == 3 then
	 state.turnCount = 0
	 world
	    :unregister( self.__index )
	    :unregister( "callPieMenu" )
	    :register( InGameWorld.pcGameflow() )
      end
   end
   return self
end
function InGameWorld.drawResourcesMarker()
   local self = System.requires {"GameState", "Resource"}
   function self:drawUI(entity)
      local resource = entity:get "Resource"

      local tempFont = love.graphics.getFont();
      local topMargin = 490
      
      love.graphics.setFont(cache.uiFont)
      for i=2, 4 do
	 love.graphics.print(tostring(resource.amount[2]), 188, topMargin +(i-2)*22)
      end
      love.graphics.setFont(tempFont)
   end
   return self
end
function InGameWorld.drawPawnStatus()
   local self = System.requires {"Pawn"}

   --[[function self:mouseMoved(entity, x, y)
      local pawn = entity:get "Pawn"
      local sprite = entity:get "Sprite"
      pawn.over = checkDotInSphere(x, y,
      sprite.x, sprite.y,
      cache.PAWN_SIZE)
      end--]]
   function self:drawUI(entity)
      local sprite = entity:get "Sprite"
      local pawn = entity:get "Pawn"

      --if not pawn.over then return end
      for i=1, pawn.life do
	 love.graphics.draw(cache.lifeIcon, sprite.x, sprite.y+(i-1)*8, 0.0, 0.02, 0.02)
      end
   end
   return self
end
function InGameWorld.showVictoryScreen()
   local self = System.requires {"GameState"}

   function self:load()
      world:assemble( RectangleButton(cache.backButton,
				      200, 450,
				      cache.backButton:getWidth(), cache.backButton:getHeight(),
				      function()
					 world = MainMenuWorld()
				      end
      ))
      world:assemble( RectangleButton(cache.quitButton,
				      400, 450,
				      cache.quitButton:getWidth(), cache.quitButton:getHeight(),
				      function()
					 love.event.quit()
				      end
      ))
   end
   function self:drawUI(entity)
      local factor = 0.6
      local topMargin = 100
      
      love.graphics.draw( cache.winBack,
			  (love.graphics.getWidth() -cache.winBack:getWidth()*factor)/2, topMargin,
			  0.0,
			  factor, factor )
      love.graphics.draw( cache.winFront,
			  (love.graphics.getWidth() -cache.winFront:getWidth()*factor)/2, topMargin +100,
			  0.0,
			  factor, factor)
   end

   return self
end
function InGameWorld.showLoseScreen()
   local self = System.requires {"GameState"}

   function self:load()
      world:assemble( RectangleButton(cache.backButton,
				      200, 450,
				      cache.backButton:getWidth(), cache.backButton:getHeight(),
				      function()
					 world = MainMenuWorld()
				      end
      ))
      world:assemble( RectangleButton(cache.quitButton,
				      400, 450,
				      cache.quitButton:getWidth(), cache.quitButton:getHeight(),
				      function()
					 love.event.quit()
				      end
      ))
   end
   function self:drawUI(entity)
      local factor = 0.6
      local topMargin = 100
      
      love.graphics.draw( cache.loseBack,
			  (love.graphics.getWidth() -cache.loseBack:getWidth()*factor)/2, topMargin,
			  0.0,
			  factor, factor )
      love.graphics.draw( cache.loseFront,
			  (love.graphics.getWidth() -cache.loseFront:getWidth()*factor)/2, topMargin +100,
			  0.0,
			  factor, factor)
   end

   return self
end


---------------------------------------------------- Gameflow
function InGameWorld.coordToIndex(i, j)
   return j*6+i+1
end
function InGameWorld.indexToCoord(index)
   local i = index%6
   local j = (index -i)/6
   return i, j
end
function InGameWorld.needUpdate(where)
   local game = world:getAllWith {"GameState"}[1]:get "GameState"
   game.needUpdate = where
end
function InGameWorld.updateTurn(cost)
   local game = world:getAllWith {"GameState"}[1]
   local state = game:get "GameState"
   local resource = game:get "Resource"
   
   state.turnCount  = state.turnCount  +1
   for i=1, 4 do resource.amount[i] = resource.amount[i] +cost[i] end
end
function InGameWorld.spawnPoint()
   local board = world:getAllWith {"BoardTile"}
   local possible = {21, 22, 27, 29, 33, 34}

   for _,i in ipairs(possible) do
      local tile = board[i]:get "BoardTile"
      if tile.faction == nil then
	 return i
      end
   end

   return nil
end
function InGameWorld.neighborhood(tileCoord)
   local i, j = InGameWorld.indexToCoord(tileCoord)
   local around = {}

   if j%2==0 then

      -- Super
      if j-1 >= 0 then
	 table.insert(around, {x=i, y=j-1})
	 if i-1>0 then
	    table.insert(around, {x=i-1, y=j-1})
	 end
      end

      -- Infer
      if j+1 < 6 then
	 table.insert(around, {x=i, y=j+1})
	 if i-1>0 then
	    table.insert(around, {x=i-1, y=j+1})
	 end
      end
      
   else

      -- Super
      if j-1 >= 0 then
	 table.insert(around, {x=i, y=j-1})
	 if i+1<6 then
	    table.insert(around, {x=i+1, y=j-1})
	 end
      end

      -- Infer
      if j+1 < 6 then
	 table.insert(around, {x=i, y=j+1})
	 if i+1<6 then
	    table.insert(around, {x=i+1, y=j+1})
	 end
      end
      
   end
   
   if i-1>0 then
      table.insert(around, {x=i-1, y=j})
   end
   if i+1<6 then
      table.insert(around, {x=i+1, y=j})
   end

   return around
end
function InGameWorld.targetList(tileCoord)
   local i = tileCoord%6
   local j = (tileCoord -i)/6
   local around = InGameWorld.neighborhood(tileCoord)

   local board = world:getAllWith {"BoardTile"}
   
   local out = {}
   for _,i in ipairs(around) do
      local coord = i.y*6 +i.x +1
      local temp = board[coord]:get "BoardTile"
      if temp.faction == "Bandeirante" then
	 table.insert(out, coord)
      end
   end

   if #out>0 then
      return out
   else
      return nil
   end
end
