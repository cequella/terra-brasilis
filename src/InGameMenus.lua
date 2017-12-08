InGame = {}

function InGame.enableInteraction()
   world
      :register( roundHighlight() )
      :register( InGame.callPieMenu() )
end
function InGame.disableInteraction()
   world
      :unregister( "roundHighlight" )
      :unregister( "callPieMenu" )
end
function InGame.innerMenu()
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
		 InGame.disableInteraction()
		 InGame.createInnerMenu(state)
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
function InGame.createInnerMenu(state)
   local backToMainMenu = function()
      world = MainMenuWorld()
   end
   local closeMenu = function()
      for i=1, #state.ingameMenu do
		 state.ingameMenu[i]:destroy()
      end
      InGame.enableInteraction()
      state.menuOpened = false
      state.menuAssembled = false
   end

   --[[
	  local videoButton = world:assemble( RectangleButton(cache.audioButton,
	  (800 -cache.audioButton:getWidth()*0.8)/2,
	  200,
	  cache.audioButton:getWidth()*0.8,
	  cache.audioButton:getHeight()*0.8,
	  backToMainMenu) )
	  local audioButton = world:assemble( RectangleButton(cache.videoButton,
	  (800 -cache.videoButton:getWidth()*0.8)/2,
	  260,
	  cache.videoButton:getWidth()*0.8,
	  cache.videoButton:getHeight()*0.8,
	  backToMainMenu) )
   --]]
   local quitButton = world:assemble( RectangleButton(cache.quitButton,
													  (800 -cache.quitButton:getWidth()*0.8)/2,
													  350,
													  cache.quitButton:getWidth()*0.8,
													  cache.quitButton:getHeight()*0.8,
													  backToMainMenu) )
   local closeButton = world:assemble( RectangleButton(cache.closeButton,
													   500,
													   150,
													   cache.closeButton:getWidth()*0.2,
													   cache.closeButton:getHeight()*0.2,
													   closeMenu) )

   --table.insert(state.ingameMenu, audioButton);
   --table.insert(state.ingameMenu, videoButton);
   table.insert(state.ingameMenu, quitButton);
   table.insert(state.ingameMenu, closeButton);

   state.menuAssembled = true
end
function InGame.callPieMenu()
   local self = System.requires{"BoardTile", "SphereCollider"}
   
   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local tile     = entity:get "BoardTile"
      local collider = entity:get "SphereCollider"
      local sprite   = entity:get "Sprite"
      local over     = checkDotInSphere(x,          y,
										collider.x, collider.y,
										collider.radius)

	  if not over then return end
	  if tile.faction==nil then return end

      local centerX = sprite.x +(sprite.width-cache.PIEMENU_BUTTON_SIZE)/2
      local centerY = sprite.y +(sprite.height-cache.PIEMENU_BUTTON_SIZE)/2

	  if tile.faction == "Guarani" then
		 entity.piemenu = guaraniPieMenu(tile, centerX, centerY)
	  elseif tile.faction == "Oca" then
		 entity.piemenu = ocaPieMenu(centerX, centerY)
	  end

      world:register( InGame.pieMenuManagement(entity, collider.x, collider.y) )
      world:unregister( self.__index )
   end

   return self
end
function InGame.pieMenuManagement(owner, centerX, centerY)
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
      
      if over == inPieRadius then -- if over XOR !inPieRadius (clear)
		 for _, option in ipairs(owner.piemenu) do
			option:destroy()
		 end
		 
		 world:register( InGame.callPieMenu() )
		 world:unregister( self.__index )
      end
   end

   return self
end

----------------
function ocaPieMenu(centerX, centerY)
   local out = {}

   local spawnPoint = InGameWorld.spawnPoint()

   local spawn
   if spawnPoint == nil then
	  spawn = RoundButton(cache.pieMenuDisabled,
						  centerX, centerY -cache.PIEMENU_RADIUS,
						  cache.PIEMENU_BUTTON_SIZE,
						  function()end)
   else
	  spawn = RoundButton(cache.pieMenu.spawn,
						  centerX, centerY -cache.PIEMENU_RADIUS,
						  cache.PIEMENU_BUTTON_SIZE,
						  function()
							 print("Recruta")
							 local temp = {spawnpoint = spawnPoint}
							 world:register( InGameWorld.spawnAction() )
							 world:assemble( SpawnAction(temp) )
						  end, "Recrutar", "AtTop")
   end
   
   table.insert(out, world:assemble(spawn))
   return out
end
function guaraniPieMenu(tile, centerX, centerY)
   local out = {}
   local attack = RoundButton(cache.pieMenu.attack,
							  centerX -cache.PIEMENU_RADIUS, centerY,
							  cache.PIEMENU_BUTTON_SIZE,
							  function()
								 print("Ataca")
							  end, "Atacar", "AtLeft")
   local move = RoundButton(cache.pieMenu.move,
							centerX +cache.PIEMENU_RADIUS, centerY,
							cache.PIEMENU_BUTTON_SIZE,
							function()
							   print("Move")
							   local temp = {from = tile.coord+1, to = 1}
							   world:register( InGameWorld.moveAction() )
							   world:assemble( MoveAction(temp) )
							end, "Mover", "AtRight")
   local collect = RoundButton(cache.pieMenu.resourceCollect,
							   centerX, centerY +cache.PIEMENU_RADIUS,
							   cache.PIEMENU_BUTTON_SIZE,
							   function()
								  print("Coleta")
								  local temp = {mineral = 1, vegetal = 1, animal = 1}
								  world:register( InGameWorld.collectAction() )
								  world:assemble( CollectAction(temp) )
							   end, "Coletar Recursos", "AtBottom")
   local upgrade = RoundButton(cache.pieMenu.upgrade,
							   centerX, centerY -cache.PIEMENU_RADIUS,
							   cache.PIEMENU_BUTTON_SIZE,
							   function()
								  print("Promove")
								  local temp = {at = tile.coord+1}
								  world:register( InGameWorld.upgradeAction() )
								  world:assemble( UpgradeAction(temp) )
							   end, "Promover", "AtTop")
   
   table.insert(out, world:assemble(attack))
   table.insert(out, world:assemble(move))
   table.insert(out, world:assemble(collect))
   table.insert(out, world:assemble(upgrade))
   return out
end
