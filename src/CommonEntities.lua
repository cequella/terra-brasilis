world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96

function Paw(faction, x, y)
   local charset = (faction=="Guarani") and cache.guarani or nil
   
   return {
      {Sprite, charset, x, y, cache.PAW_SIZE, cache.PAW_SIZE}
   }
end

function Tile(tileStates, x, y)
   local hSize = cache.TILE_SIZE/2
   return {
      {Sprite, tileStates, x, y, cache.TILE_SIZE, cache.TILE_SIZE},
      {SphereCollider, x +hSize, y +hSize, cache.TILE_SIZE*0.3, {0, 255, 255}},
      {BoardTile}
   }
end

function Game()
   return {
      {GameState}
   }
end

function ResourceMarker()
   return {
      {Sprite, cache.resourceMarker, 0, 405, 109, 92}
   }
end

function RoundButton(buttonStates, x, y, size, callback, help, helpPosition)
   local hSize = size/2

   if callback then
      return {
	 {Sprite, buttonStates, x, y, size, size},
	 {SphereCollider, x +hSize, y +hSize, hSize, {255, 255, 0}},
	 {ButtonCallback, callback},
	 {UIHelp, help, helpPosition},
	 {MouseListener}
      }
   else
      return {
	 {Sprite, buttonStates, x, y, size, size, "Unable"},
      }
   end
end

function ResourceCard(x, y)
   local spacement = 0.025*love.graphics.getWidth()
   local cWidth    = 0.750*(love.graphics.getWidth()-2*spacement)/3
   local cHeight   = 1.618*cWidth

   return {
      {Sprite, cache.card, x, y, cWidth, cHeight},
      {AABBCollider, x, y, x+cWidth, y+cHeight}
   }
end

function AdversityCard(x, y, width)
   local height = 1.618*width
   return {
      {Sprite, cache.card, x, y, width, height},
      {AABBCollider, x, y, width, height, {255, 255, 0}},
      {UIHelp, nil, "Adversidade ativa", "AtBottom"}
   }
end

function WorldClock()
   local image  = cache.clock
   local width  = image:getWidth()*0.3
   local height = image:getHeight()*0.3
   local posX   = (love.graphics.getWidth()-width)/2
   local posY   = -200
   return {
      {Sprite, image, posX, posY, width, height}
   }
end
