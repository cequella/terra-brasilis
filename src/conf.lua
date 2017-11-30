function love.conf(t)
   t.console = false
   t.accelerometerjoystick = false
   t.externalstorage = false
   t.gammacorrect = false
   
   t.window.title = "Terra Brasilis"
   t.window.icon = nil
   t.window.width = 800
   t.window.height = 600
   t.window.borderless = false
   t.window.resizable = false
   t.window.minwidth = 1
   t.window.minheight = 1
   t.window.fullscreen = false
   t.window.fullscreentype = "desktop"
   t.window.vsync = true
   t.window.msaa = 0
   t.window.display = 1
   t.window.highdpi = false
   t.window.x = nil
   t.window.y = nil
   
   t.modules.audio    = false
   t.modules.event    = true
   t.modules.graphics = true
   t.modules.image    = true
   t.modules.joystick = false
   t.modules.keyboard = true
   t.modules.math     = false
   t.modules.mouse    = true
   t.modules.physics  = false
   t.modules.sound    = false
   t.modules.system   = true
   t.modules.timer    = true
   t.modules.touch    = false
   t.modules.video    = true
   t.modules.window   = true
   t.modules.thread   = true
end
