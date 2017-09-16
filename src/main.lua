require "utils.Geometry"
require "engine.Screen"
require "engine.Menu"
require "engine.MouseObserver"

function love.load()
   mouseOb = MouseObserver.new()
   menu    = Menu.new(200, 300)

   menu:addOption("Novo Jogo",     function() print("Novo Jogo") end)
   menu:addOption("Continuar",     function() print("Continuar") end)
   menu:addOption("Configurações", function() print("Config")    end)
   menu:addOption("Sair",          function() love.event.quit()  end)

   mouseOb:attach( menu )
end

function love.mousepressed(x, y, button, istouch)
   mouseOb:notify("click", x, y, button, istouch)
end

function love.update()
   if love.keyboard.isDown("escape") then
	  love.event.quit()
   end
end
function love.draw()

   menu:display()
   
end
