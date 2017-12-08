world     = require "ecs.World"
Component = require "ecs.Component"

local TILE_SIZE = 96

function Guarani(x, y)
   return {
      {Sprite, cache.guarani, x, y, cache.PAWN_SIZE, cache.PAWN_SIZE},
	  {Pawn}
   }
end

function Bandeirante(x, y)
   return {
      {Sprite, cache.guarani, x, y, cache.PAWN_SIZE, cache.PAWN_SIZE},
	  {Pawn}
   }
end

function SpawnAction(at)
   return {
	  {Action, "Spawn", at}
   }
end

function MoveAction(at)
   return {
	  {Action, "Move", at}
   }
end

function CollectAction(at)
   return {
	  {Action, "Collect", at}
   }
end

function UpgradeAction(at)
   return {
	  {Action, "Upgrade", at}
   }
end

function AttackAction(at)
   return {
	  {Action, "attack", at}
   }
end

function Tile(tileStates, x, y, coord, faction, content)
   local hSize = cache.TILE_SIZE/2
   return {
      {Sprite, tileStates, x, y, cache.TILE_SIZE, cache.TILE_SIZE},
      {SphereCollider, x +hSize, y +hSize, cache.TILE_SIZE*0.3, {0, 255, 255}},
      {BoardTile, coord, faction, content}
   }
end

function BackgroundSound(sound, state)
   return {
      {Sound, sound, state}
   }
end

function Prop(prop, x, y, width, height)
   return {
      {Sprite, prop, x, y, width, height}
   }
end

function Game()
   return {
      {GameState},
      {Resource, 0, 0, 0, 0}
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
		 {UIHelp, help, helpPosition}
      }
   else
      return {
		 {Sprite, buttonStates, x, y, size, size, "Unable"},
      }
   end
end

function RectangleButton(buttonStates, x, y, width, height, callback, help, helpPosition)
   if callback then
      return{
		 {Sprite, buttonStates, x, y, width, height},
		 {AABBCollider, x, y, width, height, {255, 255, 0}},
		 {ButtonCallback, callback},
		 {UIHelp, help, helpPosition}
      }
   else
      return{
		 {Sprite, buttonStates, x, y, width, height, "Unable"}
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

function AdversityCard(x, y, width, duration)
   local height = 1.618*width
   return {
      {Sprite, cache.card, x, y, width, height},
      {AABBCollider, x, y, width, height, {0, 255, 255}},
      {UIHelp, nil, "Adversidade ativa", "AtBottom"},
      {Resource, duration, 0, 0, 0}
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

function AudioConfig(x, y, width)
   return {
	  {AudioUI, x, y, width}
   }
end

function VideoConfig(x ,y)
   return {
	  {VideoUI}
   }
end
