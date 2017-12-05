local PieMenuOption = {
   spawn = function(tile, sprite)
      local buttonImage
      local callback
      
      if tile.content then -- not empty
	 callback = nil
	 buttonImage = cache.pieMenuDisabled
      else
	 local posX = sprite.x +(sprite.width-cache.PAW_SIZE)/2
	 local posY = sprite.y +(sprite.height-cache.PAW_SIZE)/2

	 buttonImage = cache.pieMenu.spawn
	 callback = function()
	    tile.content = world:assemble( Paw("Guarani", posX, posY) )
	 end   
      end
      
      return buttonImage, callback, "Spawn", "AtBottom"
   end,
   attack = function()
      local buttonImage = cache.pieMenu.attack
      local callback = function()
	 print("Atacou")
      end
      
      return buttonImage, callback, "Attack", "AtLeft"
   end,
   resourceCollect = function()
      local buttonImage = cache.pieMenu.resourceCollect
      local callback = function()
	 print("Resource Collect")
      end
      
      return buttonImage, callback, "Resource Collect", "AtTop"
   end,
   upgrade = function()
      local buttonImage = cache.pieMenu.upgrade
      local callback = function()
	 print("Upgrade")
      end
      
      return buttonImage, callback, "Upgrade", "AtRight"
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
      local over     = checkDotInSphere(x,          y,
					collider.x, collider.y,
					collider.radius)
      if not over then return end

      local centerX = sprite.x -cache.PIEMENU_BUTTON_SIZE/2 +sprite.width/2 
      local centerY = sprite.y -cache.PIEMENU_BUTTON_SIZE/2 +sprite.height/2

      entity.piemenu = {}
      for i=1, 4 do
	 local xDisp = cache.PIEMENU_RADIUS*math.cos(i*math.pi/2) 
	 local yDisp = cache.PIEMENU_RADIUS*math.sin(i*math.pi/2)

	 -- Spawn option
	 local buttonImage, callback, help, position
	 if i == 1 then
	    buttonImage, callback, help, position = PieMenuOption.spawn(tile, sprite)
	 elseif i == 2 then
	    buttonImage, callback, help, position = PieMenuOption.attack(tile, sprite)
	 elseif i == 3 then
	    buttonImage, callback, help, position = PieMenuOption.resourceCollect(tile, sprite)
	 else --if i == 4 then
	    buttonImage, callback, help, position = PieMenuOption.upgrade(tile, sprite)
	 end

	 local temp = RoundButton(buttonImage,
				  centerX +xDisp, centerY +yDisp,
				  cache.PIEMENU_BUTTON_SIZE,
				  callback, help, position)
	 table.insert(entity.piemenu, world:assemble(temp))
      end

      world:register( pieMenuManagement(entity, collider.x, collider.y) )
      world:unregister( self )
   end

   return self
end

function pieMenuManagement(owner, centerX, centerY)
   local self = System.requires {"ButtonCallback", "SphereCollider", "UIHelp"}

   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local collider = entity:get "SphereCollider"
      local over     = checkDotInSphere(x,          y,
					collider.x, collider.y,
					collider.radius)
      local inPieRadius = checkDotInSphere(x,       y,
					   centerX, centerY,
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
