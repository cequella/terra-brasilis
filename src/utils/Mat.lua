require "Vec"

Mat = {}
Mat.__index = Mat

-- metatable

setmetatable(Mat, {
				__call = function(instance)
				   local self = setmetatable({}, instance)
				   instance:new()
				   return self
				end
					 }
)
------------------------------------------------------------------------------------
function Mat.check(that)
   if type(that) ~= "table" then return false end
   return that.__index == Mat.__index
end
------------------------------------------------------------------------------------
function Mat:__tostring()
   local out = "m =("

   for i=0, 3 do
	  out = out.."("

	  -- print line
	  for j=0, 3 do

		 local temp = i*4+j + 1
		 out = out..self.value[temp]

		 if j~=3 then
			out = out..", "
		 end

	  end
	  -- /print line

	  out = out..")"
	  if i~=3 then
		 out = out..", "
	  end
   end
   
   out = out..")"

   return out
end
------------------------------------------------------------------------------------
function Mat:__add(that)
   local out = Mat()
   for i=1, 16 do
	  out.value[i] = self.value[i]+that.value[i]
   end

   return out
end
------------------------------------------------------------------------------------
function Mat:__sub(that)
   local out = Mat()
   for i=1, 16 do
	  out.value[i] = self.value[i]-that.value[i]
   end

   return out
end
------------------------------------------------------------------------------------
function Mat:__mul(that)
   if type(that) == "number" then
	  local out = Mat()
	  
	  for i=1, 16 do
		 out.value[i] = self.value[i]*that
	  end

	  return out
   end

   return nil
end
------------------------------------------------------------------------------------
function Mat:__div(that)
   local out = Mat()
   for i=1, 16 do
	  out.value[i] = self.value[i]/that
   end

   return out
end
------------------------------------------------------------------------------------
function Mat:__unm(that)
   local out = Mat()
   for i=1, 16 do
	  out.value[i] = -self.value[i]
   end

   return out
end
------------------------------------------------------------------------------------
function Mat:__eq(that)
   for i=1, 16 do
	  
	  if self.value[i] ~= that.value[i] then
		 return false
	  end

   end

   return true
end
------------------------------------------------------------------------------------

-- methods


function Mat:new()
   self.value = {}
   for i=1, 16 do
	  self.value[i] = 0.0
   end
   self.value[1], self.value[6], self.value[11], self.value[16] = 1.0, 1.0, 1.0, 1.0
end
------------------------------------------------------------------------------------
function Mat:clone()
   local out = Mat

   for i=1, 16 do
	  out.value[i] = self.value[i]
   end

   return out
end
------------------------------------------------------------------------------------


-- static methods


function Mat.translation(x, y, z)
   local out = Mat()

   out.value[13], out.value[14], out.value[15] = x, y, z
   
   return out;
end
------------------------------------------------------------------------------------
function Mat.scale(x, y, z)
   local out = Mat()

   out.value[1], out.value[6], out.value[11] = x, y, z
   
   return out;
end
------------------------------------------------------------------------------------
function Mat.rotateX(angle)
   local out = Mat()
   
   local cosAngle, sinAngle = math.cos(angle), math.sin(angle)
   
   out.value[6], out.value[11] = cosAngle, cosAngle
   out.value[7], out.value[10] = sinAngle, -sinAngle
   
   return out;
end
------------------------------------------------------------------------------------
function Mat.rotateY(angle)
   local out = Mat()
   
   local cosAngle, sinAngle = math.cos(angle), math.sin(angle)

   out.value[1], out.value[11] = cosAngle, cosAngle
   out.value[3], out.value[9]  = -sinAngle, sinAngle
   
   return out;
end
------------------------------------------------------------------------------------
function Mat.rotateZ(angle)
   local out = Mat()
   
   local cosAngle, sinAngle = math.cos(angle), math.sin(angle)

   out.value[1], out.value[6] = cosAngle, cosAngle
   out.value[2], out.value[5] = sinAngle, -sinAngle
   
   return out;
end
------------------------------------------------------------------------------------
