
Vec = {}
Vec.__index = Vec

-- metatable

setmetatable(Vec, {
				__call = function(instance, x, y, z, w)
				   return instance.new(x, y, z, w)
				end
					 }
)

function Vec.check(that)
   if type(that) ~= "table" then
	  return false
   end

   return that.__index == Vec.__index
end

function Vec.new(x, y, z, w)
   local self = setmetatable({}, Vec)

   self.x = x or 0.0
   self.y = y or 0.0
   self.z = z or 0.0
   self.w = w or 0.0

   return self
end

function Vec:__tostring()
   return "v= ("..self.x..", "..self.y..", "..self.z..", "..self.w..")"
end

function Vec:__add(that)
   local out = Vec(self.x+that.x, self.y+that.y, self.z+that.z, self.w+that.w)
   return out
end

function Vec:__sub(that)
   local out = Vec(self.x-that.x, self.y-that.y, self.z-that.z, self.w-that.w)
   return out
end

function Vec:__mul(that)
   local out = Vec(self.x*that, self.y*that, self.z*that, self.w*that)
   return out
end

function Vec:__div(that)
   local out = Vec(self.x/that, self.y/that, self.z/that, self.w/that)
   return out
end

function Vec:__unm()
   local out = Vec(-self.x, -self.y, -self.z, -self.w)
   return out
end

function Vec:__eq(that)
   if self.x ~= that.x then return false end
   if self.y ~= that.y then return false end
   if self.z ~= that.z then return false end
   if self.w ~= that.w then return false end
   
   return true
end

-- methods

function Vec:clone()
   local out = Vec(self.x, self.y, self.z, self.w)
   return out
end

function Vec:dot(that)
   return self.x*that.x + self.y*that.y + self.z*that.z + self.w*that.w
end

function Vec:cross(that)
   local out = Vec()

   out.x = self.y*that.z - self.z*that.y
   out.y = self.z*that.x - self.x*that.z
   out.z = self.x*that.y - self.y*that.x
   
   return out
end

function Vec:cross2d(that)
   return self.x*that.y - self.y*that.x
end

function Vec:norm2()
   return self.x^2 + self.y^2 + self.z^2 + self.w^2
end

function Vec:norm()
   return math.sqrt( self:norm2() )
end

function Vec:normalized()
   local out = self:clone()/self:norm()
   return out
end

function Vec:projection(that)
   local out = self:normalized()
   out = that:dot(out)

   return out
end 

