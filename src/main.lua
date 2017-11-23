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

function drawClock(size)
   local image = cache.clock
   local posX  = ( love.graphics.getWidth()-image:getWidth() )/2
   local posY  = -image:getHeight()/2
   local angle = 0.166*WORLD_CLOCK

   love.graphics.push()
   love.graphics.translate(love.graphics.getWidth()/2, size*0.15 -35)
   love.graphics.scale(size/image:getWidth(), size/image:getHeight())
   love.graphics.rotate(angle)
   love.graphics.translate(-image:getWidth()/2, -image:getHeight()/2 -180)
   love.graphics.draw(cache.clock)
   love.graphics.pop()
end
function drawActiveAdversity()
   love.graphics.draw(cache.card, 200, 0, 0, 0.2, 0.2)
end
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
end
function love.keyreleased(key, scancode, isrepeat)
   world:keyboardChanged(key, "Up")
end
function love.load()
   cache = Singleton()
   
   love.window.setTitle("Terra Brasilis")
   
   world
      :register( render() )
      :register( playerUI() )
      :register( roundHighlight() )
      :register( tilePieMenu() )
      :register( showHelp() )
   
   board = Board(100, 100, 6, 6)
   player = world:assemble( Player() )
end
function love.update(dt)
   world:update(dt)

   if not VersionFlavour.v10() then
      world:mouseMoved(love.mouse.getX(), love.mouse.getY(), 0, 0, istouch)
   end

   WORLD_CLOCK = WORLD_CLOCK +0.1
end
function love.draw()
   world:draw()

   --drawClock(200)
   --drawActiveAdversity()
   --drawResourceCollect()
   
   -- Debug HUD
   if DEBUG then drawDebugHUD() end
end
