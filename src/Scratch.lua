function InGameWorld.createInnerMenu(state)
   local backToMainMenu = function()
      world = MainMenuWorld()
   end
   local closeMenu = function()
      for i=1, #state.ingameMenu do
	 state.ingameMenu[i]:destroy()
      end
      InGameWorld.enableInteraction()
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
function InGameWorld.gameflow()
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
      --[[

	 Checa adversidade
	 :se nula
	 sacar adversidade
	 Zerar contador
	 :se contador < 3
	 jogador realiza ação
	 :se custo da ação > duração da adversidade
	 custo -= duração da adversidade
	 sacar adversidade
	 adversidade -= custo
	 contador ++

      --]]
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
function drawResource()
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



----------------------------------------------------------------------
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
      
      return buttonImage, callback, "Recrutar", "AtBottom"
   end,
   attack = function()
      local buttonImage = cache.pieMenu.attack
      local callback = function()
	 print("Atacou")
      end
      
      return buttonImage, callback, "Atacar", "AtLeft"
   end,
   resourceCollect = function()
      local buttonImage = cache.pieMenu.resourceCollect
      local callback = function()
	 print("Resource Collect")
      end
      
      return buttonImage, callback, "Coletar recurso", "AtTop"
   end,
   upgrade = function()
      local buttonImage = cache.pieMenu.upgrade
      local callback = function()
	 print("Upgrade")
      end
      
      return buttonImage, callback, "Promover", "AtRight"
   end
}
function callPieMenu()
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

---------------------------------------------------------------------------------------------------
