VersionFlavour = {}

function VersionFlavour.v10()
   local aux = select(2, love.getVersion())
   return aux==10
end

function VersionFlavour.leftClick()
   if VersionFlavour.v10() then
      return love.mouse.isDown(1)
   else
      return love.mouse.isDown("l")
   end
end

function VersionFlavour.rightClick()
   if VersionFlavour.v10() then
      return love.mouse.isDown(2)
   else
      return love.mouse.isDown("r")
   end
end
