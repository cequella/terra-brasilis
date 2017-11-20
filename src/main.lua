local DEBUG = true

world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

require "CommonComponents"
require "CommonSystems"
require "CommonEntities"
require "utils.Utils"

function debugHUD()
   love.graphics.print("FPS= "..love.timer.getFPS(), 10, 10)
end

function love.keypressed(key)
   if key=="escape" then
	  love.event.quit()
   end

   if key=="space" then
   end
end
function love.keyreleased(key)
end
function love.load()
   world
   	  :register( render() )
	  :register( roundHighlight() )
	  :register( callActionMenu() )
	  --:register( pieMenuManager() )
	  --:register( pieOptionSelect() )
   
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
