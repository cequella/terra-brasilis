function genHexagon(centerX, centerY, radius)
   local out = {}
   
   for i=0, 6 do
	  local angle = i/3 * 3.14
	  local x = centerX + math.sin(angle)*radius
	  local y = centerY + math.cos(angle)*radius

	  out[i*2 +1], out[i*2 +2] = x, y
   end

   return out
end
function hexagon(mode, centerX, centerY, radius)
   love.graphics.polygon(mode, genHexagon(centerX, centerY, radius))
end
