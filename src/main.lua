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

function drawClock()
   local image = cache.clock
   local posX  = ( love.graphics.getWidth()-image:getWidth() )/2
   local posY  = -image:getHeight()/2
   local angle = 0.166*WORLD_CLOCK

   love.graphics.push()
   love.graphics.translate(love.graphics.getWidth()/2, 0)
   love.graphics.scale(0.7, 0.7)
   love.graphics.rotate(angle)
   love.graphics.translate(-image:getWidth()/2, -image:getHeight()/2)
   love.graphics.draw(cache.clock)
   love.graphics.pop()
end
function drawActiveAdversity()
   love.graphics.draw(cache.card, 200, 0, 0, 0.2, 0.2)
end

function drawDebugHUD()
   love.graphics.print("FPS= "..love.timer.getFPS(), 0, 0)

   local leftButton = VersionFlavour.leftClick()
   love.graphics.print("LeftButton= "..tostring(leftButton), 0, 12)

   local rightButton = VersionFlavour.rightClick()
   love.graphics.print("RightButton= "..tostring(rightButton), 0, 24)
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

   if key=="space" then
   end
end
function love.keyreleased(key, scancode, isrepeat)
   world:keyboardChanged(key, "Up")
end
function love.load()
   cache = Singleton()
   
   love.window.setTitle("Terra Brasilis")
   
   world
      :register( render() )
      :register( roundHighlight() )
      :register( tilePieMenu() )
   
   board = Board(100, 100, 6, 6)
end
function love.update(dt)
   world:update(dt)

   if not VersionFlavour.v10() then
      world:mouseMoved(x, y, 0, 0, istouch)
   end

   WORLD_CLOCK = WORLD_CLOCK + 0.1
end
function love.draw()
   world:draw()

   drawClock()
   drawActiveAdversity()

   -- Debug HUD
   if DEBUG then drawDebugHUD() end
end
