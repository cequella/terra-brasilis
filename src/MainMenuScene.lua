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
local function startMenu(self)
   self.menu:addOption("Novo jogo",     newGame)
	  :addOption("Continuar",     continue)
	  :addOption("Configuracoes", config)
	  :addOption("Sair",          quit)
	  :normalColor(255, 255, 255, 255)
	  :deactiveColor(0, 0, 0, 150)
	  :selectedColor(255, 0, 0, 255)
	  :setFont( love.graphics.newFont("assets/CoolinCheer.ttf", 40) )
end
---------------------------------------------------------
local function startObservers(self)
   self.observer.keyboard:attach(self.menu)
   self.observer.mouse:attach(self.menu)

   love.mousepressed = function(x, y, button, istouch)
	  self.observer.mouse:notify("click", x, y, button, istouch)
   end
   love.keypressed = function(button, key, scancode, isrepeat)
	  self.observer.keyboard:notify("press", key, scancode, isrepeat)
   end
end
---------------------------------------------------------


-- methods


function MainMenuScene:new()
   Scene.new(self, "MainMenu")

   self.observer = {mouse= MouseObserver(), keyboard= KeyboardObserver()}
   self.menu = Menu(100, 200)

   startMenu(self)
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
