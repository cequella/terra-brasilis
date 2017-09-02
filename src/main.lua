function love.update()
   mousex = love.mouse.getX()
   mousey = love.mouse.getY()
end

function love.draw()
   love.graphics.print("Ola, mundo", mousex, mousey)
end
