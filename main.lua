
Class = require 'Class'
push = require 'push'

require 'Util'

require 'Map'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- an object to contain our map data
map = Map()

 -- makes initialization of all objects and data needed by the program
function love.load()

   -- makes upscalling look pixel-y instead of blurry
    love.graphics.setDefaultFilter('nearest' , 'nearest')

    -- sets up virtual screen resolution for an authentic retro feeel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullcreen = false,
        resizable = false,
        vsync = true
    })
    
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    map:update(dt)
end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:apply('start')

    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))

    -- clear the screen using Mario backgroung blue color
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)

    -- render our map object onto the screen
    map:render()

    -- end virtual resolution
    push:apply('end')
end