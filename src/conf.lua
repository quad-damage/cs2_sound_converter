function love.conf(t)
    t.window.title = "Counter-Strike 2 Sound Converter"
    t.window.icon = "icon.png"
    t.window.vsync = 1
    t.window.width = 420
    t.window.height = 320
    t.console = false
    
    t.modules.audio = false 
    t.modules.data = true   
    t.modules.event = true  
    t.modules.font = true   
    t.modules.graphics = true   
    t.modules.image = true  
    t.modules.joystick = false  
    t.modules.keyboard = true   
    t.modules.math = true   
    t.modules.mouse = true  
    t.modules.physics = false   
    t.modules.sound = false 
    t.modules.system = false 
    t.modules.thread = true 
    t.modules.timer = false  
    t.modules.touch = false 
    t.modules.video = false  
    t.modules.window = true 
end