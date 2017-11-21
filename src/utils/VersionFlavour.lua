VersionFlavour = {}

function VersionFlavour.leftClick()
   if select(1, love.getVersion())==10 then
      return love.mouse.isDown(1)
   else
      return love.mouse.isDown("l")
   end
end

function VersionFlavour.rightClick()
   if select(1, love.getVersion())==10 then
      return love.mouse.isDown(2)
   else
      return love.mouse.isDown("r")
   end
end
