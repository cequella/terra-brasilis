require "MainMenuScene"

function love.load()

   currentScene = MainMenuScene()

end
function love.draw()

   currentScene:display()
   
end
