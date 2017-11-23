local PieMenuOption = {
   spawn = function(tile, sprite)
      local stateList = cache.pieMenu.move
      local callback
      
      if tile.content then -- not empty
	 callback = nil
      else
	 local posX = sprite.x +(sprite.width-cache.PAW_SIZE)/2
	 local posY = sprite.y +(sprite.height-cache.PAW_SIZE)/2
	 
	 callback = function()
	    tile.content = world:assemble( Paw("Guarani", posX, posY) )
	 end   
      end
      
      return stateList, callback, "Move"
   end,
   attack = function()
      local stateList = cache.pieMenu.move
      local callback = function()
	 print("Atacou")
      end
      
      return stateList, callback, "Attack"
   end,
   resourceCollect = function()
      local stateList = cache.pieMenu.move
      local callback = function()
	 love.graphics.rectangle("fill", 100, 100, 100, 100)
      end
      
      return stateList, callback, "Resource Collect"
   end,
   upgrade = function()
      local stateList = cache.pieMenu.move
      local callback = function()
	 print("Upgrade")
      end
      
      return stateList, callback, "Upgrade"
   end
}

----------------------------------------------------------------------
function tilePieMenu()
   local self = System.requires {"BoardTile", "SphereCollider"}
   
   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local tile     = entity:get "BoardTile"
      local collider = entity:get "SphereCollider"
      local sprite   = entity:get "Sprite"
      local over     = checkDotInSphere(x -collider.x,
					y -collider.y,
					collider.radius)
      if not over then return end

      local centerX = sprite.x -cache.PIEMENU_BUTTON_SIZE/2 +sprite.width/2 
      local centerY = sprite.y -cache.PIEMENU_BUTTON_SIZE/2 +sprite.height/2

      entity.piemenu = {}
      for i=1, 4 do
	 local xDisp = cache.PIEMENU_RADIUS*math.cos(i*math.pi/2) 
	 local yDisp = cache.PIEMENU_RADIUS*math.sin(i*math.pi/2)

	 -- Spawn option
	 local stateList, callback, help
	 if i == 1 then
	    stateList, callback, help = PieMenuOption.spawn(tile, sprite)
	 elseif i == 2 then
	    stateList, callback, help = PieMenuOption.attack(tile, sprite)
	 elseif i == 3 then
	    stateList, callback, help = PieMenuOption.resourceCollect(tile, sprite)
	 else --if i == 4 then
	    stateList, callback, help = PieMenuOption.upgrade(tile, sprite)
	 end

	 local temp = RoundButton(cache.pieMenu.move,
				  centerX +xDisp, centerY +yDisp,
				  cache.PIEMENU_BUTTON_SIZE,
				  callback, help)
	 table.insert(entity.piemenu, world:assemble(temp))
      end

      world:register( pieMenuManagement(entity, collider.x, collider.y) )
      world:unregister( self )
   end

   return self
end

function pieMenuManagement(owner, centerX, centerY)
   local self = System.requires {"ButtonCallback", "SphereCollider", "UIHelp"}

   function self:mouseMoved(entity, x, y)
      local collider = entity:get "SphereCollider"
      local button   = entity:get "ButtonCallback"
      local uiHelp   = entity:get "UIHelp"

      local over = checkDotInSphere(x -collider.x,
				    y -collider.y,
				    collider.radius)

      if over then
	 if uiHelp.timeOver==0 then
	    uiHelp.timeOver = love.timer.getTime()
	 end
      else
	 uiHelp.timeOver = 0
      end
   end
   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local collider = entity:get "SphereCollider"
      local over     = checkDotInSphere(x -collider.x,
					y -collider.y,
					collider.radius)
      local inPieRadius = checkDotInSphere(x -centerX,
					   y -centerY,
					   cache.PIEMENU_RADIUS +cache.PIEMENU_BUTTON_SIZE)
      
      if over then
	 local button = entity:get "ButtonCallback"
	 button.callback()
      end
      if over == inPieRadius then -- if over XOR !inPieRadius (clear)
	 for _, option in ipairs(owner.piemenu) do
	    option:destroy()
	 end
	 
	 world:register( tilePieMenu() )
	 world:unregister( self )
      end
   end

   return self
end
