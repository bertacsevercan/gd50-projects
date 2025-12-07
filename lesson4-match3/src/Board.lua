--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class {}

function Board:init(x, y, level, numRows)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}
    self.numRows = numRows

    self:initializeTiles()
end

function Board:createTile(x, y)
    -- create a new tile at X,Y with a random color and variety
    -- max colors 18
    -- max variety 6
    -- intro a new color after every 3 level
    local color = math.min(18, math.random(2 + self.level / 3))
    -- intro a new variety after every 4 level
    local variety = math.min(6, math.random(self.level / 4))
    -- shiny varient
    local shiny = math.random(math.min(8, 4 + self.level)) > 5 and true or false
    return Tile(x, y, color, variety, shiny)
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, self.numRows do
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, self.numRows do
            table.insert(self.tiles[tileY], self:createTile(tileX, tileY))
        end
    end

    while self:calculateMatches() or not self:findPossibleMatches() do
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

function Board:swapTiles(highlightedTile, newTile)
    -- swap grid positions of tiles
    local tempX = highlightedTile.gridX
    local tempY = highlightedTile.gridY

    highlightedTile.gridX = newTile.gridX
    highlightedTile.gridY = newTile.gridY
    newTile.gridX = tempX
    newTile.gridY = tempY

    -- swap tiles in the tiles table
    self.tiles[highlightedTile.gridY][highlightedTile.gridX] =
        highlightedTile

    self.tiles[newTile.gridY][newTile.gridX] = newTile
end

function Board:findPossibleMatches()
    -- horizontal
    local possibleMatches = {}
    for y = 1, self.numRows do
        local currentTile = self.tiles[y][1]

        for x = 2, self.numRows do
            local nextTile = self.tiles[y][x]

            self:swapTiles(currentTile, nextTile)

            local matches = self:calculateMatches()

            -- swap back
            self:swapTiles(nextTile, currentTile)

            if matches then
                table.insert(possibleMatches, {
                    x1 = currentTile.gridX,
                    y1 = currentTile.gridY,
                    x2 = x,
                    y2 = y
                })
                break
            else
                currentTile = self.tiles[y][x]
            end
        end
    end

    -- vertical
    for x = 1, self.numRows do
        local currentTile = self.tiles[1][x]
        for y = 2, self.numRows do
            local nextTile = self.tiles[y][x]

            self:swapTiles(currentTile, nextTile)

            local matches = self:calculateMatches()

            -- swap back
            self:swapTiles(nextTile, currentTile)

            if matches then
                table.insert(possibleMatches, {
                    x1 = currentTile.gridX,
                    y1 = currentTile.gridY,
                    x2 = x,
                    y2 = y
                })
                break
            else
                currentTile = self.tiles[y][x]
            end
        end
    end

    return #possibleMatches > 0 and possibleMatches or false
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1
    local shinyMatchNum = 1

    -- horizontal matches first
    for y = 1, self.numRows do
        local colorToMatch = self.tiles[y][1].color
        local varietyToMatch = self.tiles[y][1].variety

        matchNum = 1
        shinyMatchNum = 1

        -- every horizontal tile
        for x = 2, self.numRows do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch
                and self.tiles[y][x].variety == varietyToMatch then
                matchNum = matchNum + 1
                if self.tiles[y][x].shiny then
                    shinyMatchNum = shinyMatchNum + 1
                end
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color
                varietyToMatch = self.tiles[y][x].variety

                if shinyMatchNum >= 3 then
                    -- check if its a shiny match and clear the row
                    local match = {}

                    -- go backwards from here to beginning of rows
                    for x2 = self.numRows, 1, -1 do
                        -- add each tile to the match that's in that match
                        -- self.tiles[y][x2]:destroy()
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    -- check if its a shiny match and clear the row
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1
                shinyMatchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= self.numRows - 1 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if shinyMatchNum >= 3 then
            -- check if its a shiny match and clear the row
            local match = {}

            -- go backwards from here to beginning of rows
            for x2 = self.numRows, 1, -1 do
                -- add each tile to the match that's in that match
                --  self.tiles[y][x2]:destroy()

                table.insert(match, self.tiles[y][x2])
            end

            -- add this match to our total matches table
            table.insert(matches, match)
        end

        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for x = self.numRows, self.numRows - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, self.numRows do
        local colorToMatch = self.tiles[1][x].color
        local varietyToMatch = self.tiles[1][x].variety


        matchNum = 1
        shinyMatchNum = 1

        -- every vertical tile
        for y = 2, self.numRows do
            if self.tiles[y][x].color == colorToMatch
                and self.tiles[y][x].variety == varietyToMatch then
                matchNum = matchNum + 1
                if self.tiles[y][x].shiny then
                    shinyMatchNum = shinyMatchNum + 1
                end
            else
                colorToMatch = self.tiles[y][x].color
                varietyToMatch = self.tiles[y][x].variety


                if shinyMatchNum >= 3 then
                    -- check if its a shiny match and clear the row
                    local match = {}

                    -- go backwards from here to beginning of rows
                    for y2 = self.numRows, 1, -1 do
                        --   self.tiles[y2][x]:destroy()
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y2][x])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1
                shinyMatchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= self.numRows - 1 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if shinyMatchNum >= 3 then
            -- check if its a shiny match and clear the row
            local match = {}

            -- go backwards from here to beginning of rows
            for y2 = self.numRows, 1, -1 do
                --   self.tiles[y2][x]:destroy()

                -- add each tile to the match that's in that match
                table.insert(match, self.tiles[y2][x])
            end

            -- add this match to our total matches table
            table.insert(matches, match)
        end

        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for y = self.numRows, self.numRows - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

function Board:update(dt)
    for k, tiles in pairs(self.tiles) do
        for k, tile in pairs(tiles) do
            tile:update(dt)
        end
    end
end

function Board:destroyShiny()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            local currentTile = self.tiles[tile.gridY][tile.gridX]
            if currentTile.shiny then
                currentTile:destroy()
            end
        end
    end
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, self.numRows do
        local space = false
        local spaceY = 0

        local y = self.numRows
        while y >= 1 do
            -- if our last tile was a space...
            local tile = self.tiles[y][x]

            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, self.numRows do
        for y = self.numRows, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then
                local tile = self:createTile(x, y)
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
            self.tiles[y][x]:renderParticles(self.x, self.y)
        end
    end
end
