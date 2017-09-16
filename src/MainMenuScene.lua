require "engine.Menu"
require "engine.MouseObserver"
require "engine.KeyboardObserver"
require "engine.Scene"

MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

-- metatable

setmetatable(MainMenuScene, {
				__index = Scene,
				__call = function(instance)
				   local self = setmetatable({}, instance)
				   instance:new()
				   return self
				end
						}
)

-- private
local function newGame()
   print("New Game")
end
---------------------------------------------------------
local function continue()
   print("Continue")
end
---------------------------------------------------------
local function config()
   print("Config")
end
---------------------------------------------------------
local function quit()
   love.event.quit()
end
---------------------------------------------------------
local function startMenu(menu)
   menu:addOption("Novo jogo",     newGame)
   menu:addOption("Continuar",     continue)
   menu:addOption("Configurações", config)
   menu:addOption("Sair",          quit)
end
---------------------------------------------------------
local function startObservers(self)
   self.observer.keyboard:attach(self.menu)
   self.observer.mouse:attach(self.menu)

   love.mousepressed = function(x, y, button, istouch)
	  scene.observer.mouse:notify("click", x, y, button, istouch)
   end
   love.keypressed = function(button, key, scancode, isrepeat)
	  scene.observer.keyboard:notify("press", key, scancode, isrepeat)
   end
end
---------------------------------------------------------


-- methods


function MainMenuScene:new()
   Scene.new(self, "MainMenu")

   self.observer = {mouse= MouseObserver(), keyboard= KeyboardObserver()}
   self.menu = Menu(100, 200)

   startMenu(self.menu)
   startObservers(self)
end
---------------------------------------------------------
function MainMenuScene:display()
   self.menu:display()
end
---------------------------------------------------------
function MainMenuScene:onKeyPressed(key, scancode, isrepeat)

   if key == 'escape' then
	  love.event.close()
   end

end
---------------------------------------------------------
