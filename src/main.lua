local DEBUG           = true
local GAMA_MOUSE_DOWN = false;
local WORLD_CLOCK     = 0

world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

require "Singleton"
require "CommonComponents"
require "CommonSystems"
require "CommonEntities"
require "utils.Utils"
require "utils.VersionFlavour"

function drawResourceCollect()
   local spacement = 0.025*love.graphics.getWidth()
   local cWidth    = 0.750*(love.graphics.getWidth()-2*spacement)/3
   local cHeight   = 1.618*cWidth
   local initX     = 0.125*love.graphics.getWidth()

   for i=0, 2 do
      love.graphics.draw(cache.card,
						 initX+i*(spacement+cWidth), 100,
						 0,
						 cWidth/cache.card:getWidth(), cHeight/cache.card:getHeight())
   end
end

function drawDebugHUD()
   love.graphics.setColor(0, 0, 0, 180)
   love.graphics.rectangle("fill", 0, 0, 120, 50)
   
   love.graphics.setColor(255, 255, 255)
   
   love.graphics.print("FPS= "..love.timer.getFPS(), 0, 0)

   local leftButton = VersionFlavour.leftClick()
   love.graphics.print("LeftButton= "..tostring(leftButton), 0, 12)

   local rightButton = VersionFlavour.rightClick()
   love.graphics.print("RightButton= "..tostring(rightButton), 0, 24)

   love.graphics.print("Window= "..tostring(love.graphics.getWidth()).."x"..
						  tostring(love.graphics.getHeight()), 0, 36)
end

function love.mousepressed(x, y, button, istouch)
   GAMA_MOUSE_DOWN = true
   world:mouseChanged(x, y, "Down", button, istouch)
end
function love.mousereleased(x, y, button, istouch)
   if GAMA_MOUSE_DOWN then
      GAMA_MOUSE_DOWN = false
      world:mouseClick(x, y, button, istouch)
   end
   world:mouseChanged(x, y, "Up", button, istouch)
end
function love.mousemoved(x, y, dx, dy, istouch)
   world:mouseMoved(x, y, dx, dy, istouch)
end
function love.wheelmoved(x, y)
   world:mouseWheel(x, y)
end
function love.keypressed(key, scancode, isrepeat)
   world:keyboardChanged(key, "Down")

   if key=="escape" then
      love.event.quit()
   end

   if key == '1' then
	  message = nil
   elseif key=='2' then
	  message = cache.winMessage
   elseif key=='3' then
	  message = cache.loseMessage
   end
end
function love.keyreleased(key, scancode, isrepeat)
   world:keyboardChanged(key, "Up")
end
function love.load()
   background = love.graphics.newImage("assets/background2.jpg")
   cache = Singleton()
   
   love.window.setTitle("Terra Brasilis")
   
   world
      :register( render() )
      :register( gameUI() )
      :register( roundHighlight() )
	  :register( squareHighlight() )
      :register( tilePieMenu() )
      :register( showHelp() )
   
   game = world:assemble( Game() )
end
function love.update(dt)
   world:update(dt)

   if not VersionFlavour.v10() then
      world:mouseMoved(love.mouse.getX(), love.mouse.getY(), 0, 0, istouch)
   end
end
function love.draw()
   love.graphics.draw(background)
   world:draw()
   if message then love.graphics.draw(message) end

   --drawClock(200)
   --drawActiveAdversity()
   --drawResourceCollect()
   
   -- Debug HUD
   if DEBUG then drawDebugHUD() end
end
