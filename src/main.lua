local DEBUG = true

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

   local leftButton = (select(1, love.getVersion())==10) and love.mouse.isDown(1) or love.mouse.isDown("l")
   love.graphics.print("LeftButton= "..tostring(leftButton), 0, 12)

   local rightButton = (select(1, love.getVersion())==10) and love.mouse.isDown(2) or love.mouse.isDown("r")
   love.graphics.print("RightButton= "..tostring(rightButton), 0, 24)
end


function love.mousepressed(x, y, button, istouch)
   world:mouseChanged(x, y, "Down", button, istouch)
end
function love.mousereleased(x, y, button, istouch)
   world:mouseChanged(x, y, "Up", button, istouch)
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
   
   board = Board(100, 100, 3, 3)
end
function love.update(dt)
   world:update(dt)
end
function love.draw()
   world:draw()

   -- Debug HUD
   if DEBUG then
      debugHUD()
   end
end
