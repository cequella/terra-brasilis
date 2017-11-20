world     = require "ecs.World"
Component = require "ecs.Component"
System    = require "ecs.System"

require "CommonComponents"
require "CommonSystems"
require "CommonEntities"
require "utils.Utils"

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
	  :register( roundHighlight() )
   	  :register( render() )
	  :register( callActionMenu() )
	  :register( pieMenuManager() )

   board = Board(100, 100, 6, 6)
end
function love.update(dt)
   world:update(dt)
end
function love.draw()
   world:draw()
end
