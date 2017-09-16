require "MainMenuScene"

function love.load()
   scene = MainMenuScene()
end
function love.update()
   if love.keyboard.isDown("escape") then
	  love.event.quit()
   end
end
function love.draw()

   scene:display()
   
end
