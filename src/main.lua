local DEBUG           = true
local GAMA_MOUSE_DOWN = false;

world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

require "CommonComponents"
require "CommonSystems"
require "CommonEntities"
require "utils.Utils"
require "utils.VersionFlavour"

function debugHUD()
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
   love.window.setTitle("Terra Brasilis")
   
   world
      :register( render() )
      :register( roundHighlight() )
      :register( callActionMenu() )
   
   board = Board(100, 100, 6, 6)
end
function love.update(dt)
   world:update(dt)

   if not VersionFlavour.v10() then
      world:mouseMoved(x, y, 0, 0, istouch)
   end
end
function love.draw()
   world:draw()

   -- Debug HUD
   if DEBUG then
      debugHUD()
   end
end
