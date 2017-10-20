require "MainMenuScene"

function love.load()
   love.window.setTitle("Terra Brasilis")
   
   currentScene = MainMenuScene()
end
function love.draw()
   
   currentScene:display()
   
end
