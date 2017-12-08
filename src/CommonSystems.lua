local suit = require "suit"

require "PieMenuSystem"
require "InGameSystem"

world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

function render()
   local self = System.requires {"Sprite"}

   function self:draw(entity)
      local sprite   = entity:get "Sprite"

      if sprite.highlight ~= nil then
	 love.graphics.setColor(sprite.highlight)
      else
	 love.graphics.setColor(sprite.color)
      end
      love.graphics.draw(sprite.image,
			 sprite.x, sprite.y,
			 0,
			 sprite.sx, sprite.sy)
      love.graphics.setColor(255, 255, 255)
   end

   return self
end

function showHelp()
   local self = System.requires {"Sprite", "UIHelp"}

   function self:update(entity)
      local sprite = entity:get "Sprite"
      local uiHelp = entity:get "UIHelp"

      if sprite.state == "MouseOver" then
	 if uiHelp.timeOver==0 then
	    uiHelp.timeOver = love.timer.getTime()
	 end
      else
	 uiHelp.timeOver = 0
      end
   end
   function self:drawUI(entity)
      local sprite = entity:get "Sprite"
      local uiHelp = entity:get "UIHelp"

      if not uiHelp.message then return end
      if uiHelp.timeOver>0 then
	 local font   = love.graphics.getFont()
	 local deltaT = love.timer.getTime() -uiHelp.timeOver
	 if deltaT<cache.feedback then return end
	 
	 local posX
	 local posY
	 
	 -- Positioning
	 if uiHelp.position == "AtRight" then
	    posX = sprite.x +sprite.width +10
	    posY = sprite.y +(sprite.height -font:getHeight())/2
	 elseif uiHelp.position == "AtBottom" then
	    posX = sprite.x +(sprite.width -font:getWidth(uiHelp.message))/2
	    posY = sprite.y +sprite.height +10
	 elseif uiHelp.position == "AtTop" then
	    posX = sprite.x +(sprite.width -font:getWidth(uiHelp.message))/2
	    posY = sprite.y -font:getHeight() -10
	 elseif uiHelp.position == "AtLeft" then
	    posX = sprite.x -font:getWidth(uiHelp.message) -10
	    posY = sprite.y +(sprite.height -font:getHeight())/2
	 end

	 -- Draw rectangle
	 love.graphics.setColor(0, 0, 0, 180)
	 love.graphics.rectangle("fill",
				 posX -5, posY -5,
				 font:getWidth(uiHelp.message) +10, font:getHeight() +10,
				 6,6,3)
	 
	 -- Write text
	 love.graphics.setColor(255, 255, 255)
	 love.graphics.print(uiHelp.message, posX, posY)
      end
   end

   return self
end

function roundHighlight()
   local self = System.requires {"Sprite", "SphereCollider"}

   function self:mouseMoved(entity, x, y)
      local sprite   = entity:get "Sprite"
      local collider = entity:get "SphereCollider"
      local over     = checkDotInSphere(x,          y,
					collider.x, collider.y,
					collider.radius)

      sprite.highlight = over and collider.highlight or nil
      sprite.state = over and "MouseOver" or "Default"
   end

   return self
end

function squareHighlight()
   local self = System.requires {"Sprite", "AABBCollider"}

   function self:mouseMoved(entity, x, y)
      local sprite   = entity:get "Sprite"
      local collider = entity:get "AABBCollider"
      local over     = checkDotInRect(x, y,
				      collider.x, collider.y,
				      collider.width, collider.height)

      sprite.highlight = over and collider.highlight or nil
      sprite.state = over and "MouseOver" or "Default"
   end

   return self
end

function playSound()
   local self = System.requires {"Sound"}

   function self:update(entity, dt)
      local sound = entity:get "Sound"

      if     sound.state == "Play"   then love.audio.play(sound.content)
      elseif sound.state == "Pause"  then love.audio.pause(sound.content)
      elseif sound.state == "Stop"   then love.audio.stop(sound.content)
      elseif sound.state == "Resume" then love.audio.resume(sound.content)
      elseif sound.state == "Rewind" then love.audio.rewind(sound.content)
      end

   end
   
   return self
end

function rectButtonCallbackExecute()
   local self = System.requires {"ButtonCallback", "AABBCollider"}

   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local collider = entity:get "AABBCollider"
      local over     = checkDotInRect(x,              y,
				      collider.x,     collider.y,
				      collider.width, collider.height)
      if over then
	 local button = entity:get "ButtonCallback"
	 love.audio.play(cache.buttonFeedback)
	 button.callback()
      end

   end
   
   return self
end

function roundButtonCallbackExecute()
   local self = System.requires {"ButtonCallback", "SphereCollider"}

   function self:mouseClick(entity, x, y, button)
      if not VersionFlavour.isLeft(button) then return end

      local collider = entity:get "SphereCollider"
      local over     = checkDotInSphere(x,          y,
					collider.x, collider.y,
					collider.radius)
      if over then
	 local button = entity:get "ButtonCallback"
	 love.audio.play(cache.buttonFeedback)
	 button.callback()
      end

   end
   
   return self
end

function showAudioConfig()
   local self = System.requires {"AudioUI"}

   function self:update(entity, dt)
      local ui = entity:get "AudioUI"
      suit.layout:reset(ui.position.x, ui.position.y)

      -- Main music
      suit.Label("Música", {align = "center"}, suit.layout:row(ui.width, 12))
      suit.Slider(cache.main, suit.layout:row(ui.width, 12))
      cache.nightSound:setVolume(cache.main.value)

      -- Effects
      suit.Label("Efeitos", {align = "center"}, suit.layout:row(ui.width, 12))
      suit.Slider(cache.effect, suit.layout:row(ui.width, 12))
      cache.buttonFeedback:setVolume(cache.effect.value)
   end
   function self:draw(entity)
      suit.draw()
   end

   return self
end
