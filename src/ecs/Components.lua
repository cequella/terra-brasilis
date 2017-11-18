Drawable = {}
setmetatable(Drawable,{
				__call = function(instance, src, width, height)
				   local self  = setmetatable({}, instance)
				   self.image  = love.graphics.newImage(src)
				   self.width  = width and width/self.image:getWidth() or 1.0
				   self.height = height and height/self.image:getHeight() or 1.0
				   return self
				end
					  }
)

Position = {}
setmetatable(Position,{
				__call = function(instance, x, y)
				   local self  = setmetatable({}, instance)
				   self.x = x
				   self.y = y
				   return self
				end
					  }
)

Displacement = {}
setmetatable(Displacement,{
				__call = function(instance, vx, vy)
				   local self  = setmetatable({}, instance)
				   self.vx = vx
				   self.vy = vy
				   return self
				end
					  }
)
