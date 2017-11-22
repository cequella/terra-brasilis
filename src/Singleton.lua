Singleton = {}
Singleton.__index = Singleton
setmetatable(Singleton, {
		__call = function(instance)
		   return Singleton.new(instance)
		end
			}
)

function Singleton.new(instance)
   local self = setmetatable({}, instance)

   self.TILE_SIZE           = 96
   self.PIEMENU_BUTTON_SIZE = 30
   self.PIEMENU_RADIUS      = 48
   self.PAW_SIZE            = 64

   self.card  = love.graphics.newImage("assets/card.jpg")
   self.clock = love.graphics.newImage("assets/SunAndMoon.png")
   self.tileImage = {
      ["Default"]   = love.graphics.newImage("assets/tile.png"),
      ["MouseOver"] = love.graphics.newImage("assets/tileS.png"),
      ["Denied"]    = love.graphics.newImage("assets/tileD.png")
   }
   self.pieMenu = {
      spawn = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      },
      move = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      },
      attack = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      },
      upgrade = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      },
      craft = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      },
      resourceCollect = {
	 ["Default"]   = love.graphics.newImage("assets/tempButton.png"),
	 ["MouseOver"] = love.graphics.newImage("assets/tempButtonO.png"),
	 ["Unable"]    = love.graphics.newImage("assets/tempButtonU.png")
      }
   }

   self.guarani = love.graphics.newImage("assets/bart.png")

   return self
end
