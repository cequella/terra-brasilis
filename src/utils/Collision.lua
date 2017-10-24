
Collision = {}

function Collision:dotAABB(dotx, doty,
						   aabbx, aabby,
						   halfWdith, halfHeight)
   if dotx < aabbx -halfWidth  then return false end
   if dotx > aabbx +halfWidth  then return false end
   if doty < aabby -halfHeight then return false end
   if doty > aabby +halfHeight then return false end

   return true
end
