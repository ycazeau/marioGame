 
function generateQuads(atlas, titlewidth, titleheight)
    local sheetWidth = atlas:getWidth()/titlewidth
    local sheetHeight = atlas.getHeight / titleheight

    local sheetCounter = 1
    local quads = {}

    for y = 0, sheetHeight -1 do
        for x = 0, sheetWidth - 1 do
        quads[sheetCounter] = love.graphics.newQuad(x*titlewidth, y * titleheight, titlewidth, titleheight, atlas:getDimensions())

        end
    end

    return quads

end
