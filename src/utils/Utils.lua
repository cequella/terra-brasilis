function table.new(orig)
   local origType = type(orig)
   local copy

   if origType == "table" then
	  copy = {}
	  for origKey, origValue in next, orig, nil do
		 copy[ table.new(origkey) ] = table.new( origValue )
	  end
   else
	  copy = orig
   end
   return copy
end

function checkDotInSphere(x, y, sx, sy, radius)
   return ((sx-x)^2 + (sy-y)^2)<(radius^2)
end

function checkDotInRect(x, y, rx, ry, rwidth, rheight)
   if x < rx then return false end
   if x > rx+rwidth then return false end
   if y < ry then return false end
   if y > ry+rheight then return false end

   return true
end
