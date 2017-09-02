function love.update()
   mousex = love.mouse.getX()
   mousey = love.mouse.getY()
end

function love.draw()
   love.graphics.print("VAAAAIII SIMBOOORA", mousex, mousey)
end
