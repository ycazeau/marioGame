
--[[ contains tile data and necessary code for rendering a tile]]
require 'Util'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 4 

local SCROLL_SPEED = 62

-- the constuctor for our map object
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.camX = 0
    self.camY = -3

    -- generate a quad (individual frame / sprite) for each tile
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- Filling the map with empty Tiles   
    for y = 1, self.mapHeight / 2 do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- Starts halfway down the map, populates with bricks
    for y = self.mapHeight / 2, self.mapHeight do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end
    end

end

-- function to update camera offset with delta time
function Map:update(dt)

    if love.keyboard.isDown('w') then 
        -- up movement
        self.camY = math.max(0, math.floor(self.camY + dt * -SCROLL_SPEED))
    elseif love.keyboard.isDown('a') then
         -- left movement
         self.camX = math.max(0, math.floor(self.camX + dt * -SCROLL_SPEED))
    elseif love.keyboard.isDown('s') then
         -- down movement
         self.camY= math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, math.floor(self.camY + dt * SCROLL_SPEED))
    elseif love.keyboard.isDown('d') then
         -- right movement
         self.camX = math.min(self.mapWidthPixels - VIRTUAL_WIDTH, math.floor(self.camX + dt * SCROLL_SPEED))
    
    end
   
end

-- returns an integer for the title at the given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a title at the given x-y coordinate to an integer value
function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end

-- renders our map to the screen, to be called by main's render
function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do 
            if self:getTile(x, y) ~= TILE_EMPTY then
            love.graphics.draw(self.spritesheet, self.tileSprites [self: getTile(x, y)],
            (x - 1 ) * self.tileWidth, (y -1) * self.tileHeight)
            end
        end
    end
end