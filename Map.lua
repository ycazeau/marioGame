
--[[ contains tile data and necessary code for rendering a tile]]
require 'Util'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 4 


-- the constuctor for our map object
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    -- generate a quad (individual frame / sprite) for each tile
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

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