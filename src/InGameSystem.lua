
function gameUI()
   local self = System.requires {"GameState"}

   function self:load(entity)
      local game = entity:get "GameState"

	  -- Create a board
	  local board = game.boardDimen

	  for i=0, board.height-1 do
		 for j=0, board.width-1 do
			local posX = (i%2==0) and board.x +j*board.xStep or board.x +board.xStep*(j+0.5)
			local posY = board.y +i*board.yStep
			world:assemble( Tile(cache.tileImage, posX, posY) )
		 end
	  end

	  -- Create active adversity place
	  world:assemble( AdversityCard(250, 0, 30) )

	  -- Create a clock
      game.clockEntity = world:assemble( WorldClock() )
   end
   
   function self:update(entity)
      local game = entity:get "GameState"
	  
      -- Update Clock
      game.clock = game.clock +0.1
   end

   function self:draw(entity)
	  love.graphics.setColor(255, 0, 0)
	  love.graphics.print("Carne= 0", 0, 400)
	  love.graphics.setColor(0, 255, 0)
	  love.graphics.print("Ervas= 0", 0, 412)
	  love.graphics.setColor(0, 0, 255)
	  love.graphics.print("Minério= 0", 0, 424)
	  love.graphics.setColor(255, 255, 255)
   end

   return self
end
