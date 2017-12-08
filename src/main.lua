--local DEBUG           = true
local GAMA_MOUSE_DOWN = false
local WORLD_CLOCK     = 0

require "Singleton"
require "CommonComponents"
require "CommonSystems"
require "CommonEntities"
require "utils.Utils"
require "utils.VersionFlavour"

require "MainMenuWorld"
require "InGameWorld"
require "AudioConfigWorld"
require "VideoConfigWorld"
require "ConfigWorld"
require "TutorialWorld"
require "CreditsWorld"

math.randomseed(os.time())

function drawDebugHUD()
   love.graphics.setColor(0, 0, 0, 180)
   love.graphics.rectangle("fill", 0, 0, 120, 80)
   
   love.graphics.setColor(255, 255, 255)
   
   love.graphics.print("FPS= "..love.timer.getFPS(), 0, 0)

   local leftButton = VersionFlavour.leftClick()
   love.graphics.print("LeftButton= "..tostring(leftButton), 0, 12)

   local rightButton = VersionFlavour.rightClick()
   love.graphics.print("RightButton= "..tostring(rightButton), 0, 24)

   love.graphics.print("Window= "..tostring(love.graphics.getWidth()).."x"..
			  tostring(love.graphics.getHeight()), 0, 36)
   love.graphics.print("#Entity= "..tostring(#world.entityList), 0, 48)
   love.graphics.print("#System= "..tostring(#world.systemList), 0, 60)
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
end
function love.keyreleased(key, scancode, isrepeat)
   world:keyboardChanged(key, "Up")
end
function love.load()
   cache = Singleton()
   world = MainMenuWorld()
   --world = InGameWorld()
   --world = AudioConfigWorld()
   --world = VideoWorld()
   --world = ConfigWorld()
   --world = CreditsWorld()
   --world = TutorialWorld()
end
function love.update(dt)
   world:update(dt)

   if not VersionFlavour.v10() then
      world:mouseMoved(love.mouse.getX(), love.mouse.getY(), 0, 0, istouch)
   end
end
function love.draw()
   world:draw()
   world:drawUI()

   if DEBUG then drawDebugHUD() end
end
