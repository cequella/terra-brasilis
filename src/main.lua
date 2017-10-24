require "MainMenuScene"
require "InGameScene"

function love.load()
   love.window.setTitle("Terra Brasilis")
   
   currentScene = InGameScene()
end
function love.draw()
   
   currentScene:display()
   
end
