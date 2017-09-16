require "utils.Geometry"
require "engine.Menu"
require "engine.MouseObserver"
require "engine.KeyboardObserver"
require "engine.Scene"

function love.load()
   menu = Menu(100, 200)

   menu:addOption("Novo jogo")
   menu:addOption("Continuar")
   menu:addOption("Sair")
end
function love.update()
   if love.keyboard.isDown("escape") then
	  love.event.quit()
   end
end
function love.draw()
   menu:display()
   
end
