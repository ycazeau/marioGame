
--[[ contains tile data and necessary code for rendering a tile]]
require 'Util'

require 'Player'

Map = Class{}

-- bricks tiles
TILE_BRICK = 1
TILE_EMPTY = -1

-- cloud tiles
CLOUD_LEFT = 6
CLOUD_RIGHT = 7

-- bush tiles
BUSH_LEFT = 2
BUSH_RIGHT = 3

-- mushroom tiles
MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

-- jump block
JUMP_BLOCK = 5
JUMP_BLOCK_HIT = 9

-- a speed to multiply delta time to scrool map: smooth value
local SCROLL_SPEED = 62

-- the constuctor for our map object
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.sprites = generateQuads(self.spritesheet, 16, 16)

    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    -- camera offset
    self.camX = 0
    self.camY = -3

    self.player = Player(self)

    -- generate a quad (individual frame / sprite) for each tile
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    -- cache width and height of map in pixels
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- Filling the map with empty Tiles   
    for y = 1, self.mapHeight  do
        for x = 1, self.mapWidth do
            -- support for multiple sheets per tile; storing tiles as tables
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- begin generating the terrain using vertical scan lines
    local x = 1
    while x < self.mapWidth do

        -- 2% chance to generate a cloud
        -- make sure we're 2w tiles from the edge at least
        if x < self.mapWidth - 2 then
            if math.random(20) == 1 then

                -- choose a random vertical spot above where blocks/pipes generate
                local cloudStart = math.random(self.mapHeight / 2 - 6)

                self:setTile(x, cloudStart, CLOUD_LEFT)
                self:setTile(x + 1, cloudStart, CLOUD_RIGHT)
            end
        end

        -- 5% chance to generate a mushroom
        if math.random(20) == 1 then
            -- left side of pipe
            self:setTile(x, self.mapHeight / 2 - 2 , MUSHROOM_TOP)
            self:setTile(x, self.mapHeight / 2 - 1, MUSHROOM_BOTTOM)

            -- creates column of the tiles going to the bottom of the map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end

            -- next vertical scan line
            x =x + 1

        -- 10% chance to generate bush, being sure to generate away from edge
        elseif math.random(10) == 1 and x < self.mapWidth - 3 then
            local bushLevel = self.mapHeight / 2 - 1

            --place bush component and then column bricks
            self:setTile(x, bushLevel, BUSH_LEFT)
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            self:setTile(x, bushLevel, BUSH_RIGHT)
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x,y, TILE_BRICK)
            end
            
            -- next vertical scan line
            x = x + 1

        -- 10% chance to not generate anything, creating a gap
        elseif math.random(10) ~= 1 then

            -- crates column od tiles going to bottom of map
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end

        -- chance to create a block for Mario to hit
        if math.random(15) == 1 then
            self:setTile(x, self.mapHeight / 2 -4, JUMP_BLOCK)            
        end

        -- next vertical scan line
        x = x + 1
        else 
            -- increment X so we skip two scanlines, crating a 2-tile gap
            x = x + 2
        end
    end

    
    -- Starts halfway down the map, populates with bricks
    for y = self.mapHeight / 2, self.mapHeight do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end
    end

end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK, JUMP_BLOCK, JUMP_BLOCK_HIT,
        MUSHROOM_TOP, MUSHROOM_BOTTOM
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end        
    end
    
    return false
end

-- function to update camera offset with delta time
function Map:update(dt)

    self.player:update(dt)

    self.camX = math.max(0, math.min(self.player.x - VIRTUAL_WIDTH / 2,
    math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.player.x)))
   
end

-- gets the tile type at the given pixel coordinate
function Map:tileAt(x, y)
    return self.getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
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

    self.player:render()
end