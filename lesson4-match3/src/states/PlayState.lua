--[[
    GD50
    Match-3 Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    State in which we can actually play, moving around a grid cursor that
    can swap two tiles; when two tiles make a legal swap (a swap that results
    in a valid match), perform the swap and destroy all matched tiles, adding
    their values to the player's point score. The player can continue playing
    until they exceed the number of points needed to get to the next level
    or until the time runs out, at which point they are brought back to the
    main menu or the score entry menu if they made the top 10.
]]

PlayState = Class { __includes = BaseState }

function PlayState:init()
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 1

    -- position in the grid which we're highlighting
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    -- flag to show whether we're able to process input (not swapping or clearing)
    self.canInput = true

    -- tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil

    self.score = 0
    self.timer = 90

    self.showHint = false
    self.hintHighlight = { x = 1, y = 1 }

    -- set our Timer class to turn cursor highlight on and off
    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)

    -- subtract 1 from timer every second
    Timer.every(1, function()
        self.timer = self.timer - 1

        -- play warning sound on timer if we get low
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    -- grab level # from the params we're passed
    self.level = params.level

    self.numRows = params.numRows

    -- spawn a board and place it toward the right
    self.board = params.board or Board(BOARD_START_X, BOARD_START_Y, self.level, self.numRows)

    -- grab score from params if it was passed
    self.score = params.score or 0

    -- score we have to reach to get to the next level
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- go back to start if time runs out
    if self.timer <= 0 then
        -- clear timers from prior PlayStates
        Timer.clear()

        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    -- go to next level if we surpass score goal
    if self.score >= self.scoreGoal then
        -- clear timers from prior PlayStates
        -- always clear before you change state, else next state's timers
        -- will also clear!
        Timer.clear()

        gSounds['next-level']:play()

        -- change to begin game state with new level (incremented)
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    if self.canInput then
        local mouseMoved = love.mouse.getCurrentPos()
        if mouseMoved["x"] then
            local mouseX = mouseMoved["x"]
            local mouseY = mouseMoved["y"]

            local x = math.floor((mouseX - BOARD_START_X) / 32)
            local y = math.floor((mouseY - BOARD_START_Y) / 32)

            -- prevent going too low or high
            if x < 0 then
                x = 0
            elseif x > self.numRows - 1 then
                x = self.numRows - 1
            end

            if y < 0 then
                y = 0
            elseif y > self.numRows - 1 then
                y = self.numRows - 1
            end

            self.boardHighlightY = y
            self.boardHighlightX = x
        end

        if love.mouse.wasClicked(1) then
            -- programmatically press 'enter'
            love.keyboard.keysPressed['enter'] = true
        end

        if love.mouse.wasClicked(2) then
            local possibleMatches = self.board:findPossibleMatches()
            self:showHintSequence(possibleMatches, 1)
        end

        -- move cursor around based on bounds of grid, playing sounds
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(self.numRows - 1, self.boardHighlightY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(self.numRows - 1, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        -- if we've pressed enter, to select or deselect a tile...
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            -- if same tile as currently highlighted, deselect
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1

            -- if nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]

                -- if we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

                -- if the difference between X and Y combined of this highlighted tile
                -- vs the previous is not equal to 1, also remove highlight
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            else
                local newTile = self.board.tiles[y][x]

                self.board:swapTiles(self.highlightedTile, newTile)

                local matches = self.board:calculateMatches()
                if matches then
                    -- tween coordinates between the two so they swap
                    Timer.tween(0.1, {
                        [self.highlightedTile] = { x = newTile.x, y = newTile.y },
                        [newTile] = { x = self.highlightedTile.x, y = self.highlightedTile.y }
                    })

                    -- once the swap is finished, we can tween falling blocks as needed
                        :finish(function()
                            self:calculateMatches(matches)
                        end)
                else
                    gSounds['error']:stop()
                    gSounds['error']:play()
                    self.board:swapTiles(newTile, self.highlightedTile)
                    -- swap tiles back visually
                    Timer.tween(0.2, {
                        [self.highlightedTile] = { x = newTile.x, y = newTile.y },
                        [newTile] = { x = self.highlightedTile.x, y = self.highlightedTile.y }

                    }):finish(function()
                        Timer.tween(0.2, {
                            [self.highlightedTile] = { x = newTile.x, y = newTile.y },
                            [newTile] = { x = self.highlightedTile.x, y = self.highlightedTile.y }

                        }):finish(function()
                            self.highlightedTile = nil
                        end)
                    end)
                end
            end
        end
    end
    self.board:update(dt)
    Timer.update(dt)
end

function PlayState:showHintSequence(matches, index)
    -- show 3 hints at most
    if index <= 3 then
        index = index or 1
        if matches[index] then
            local match = matches[index]
            self.hintHighlight.x = match.x1
            self.hintHighlight.y = match.y1
            self.showHint = true
            self.canInput = false

            Timer.tween(0.6, {
                [self.hintHighlight] = { x = match.x2, y = match.y2 }
            }):finish(function()
                self.showHint = false

                -- Move to the next match after a short delay
                Timer.after(0.3, function()
                    self:showHintSequence(matches, index + 1)
                end)
            end)
        else
            self.canInput = true
        end
    else
        self.canInput = true
    end
end

--[[
    Calculates whether any matches were found on the board and tweens the needed
    tiles to their new destinations if so. Also removes tiles from the board that
    have matched and replaces them with new randomized tiles, deferring most of this
    to the Board class.
]]
function PlayState:calculateMatches(matches)
    if not self.board:findPossibleMatches() then
        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.score
        })
    end
    self.highlightedTile = nil

    -- if we have any matches, remove them and tween the falling blocks that result
    --local matches = self.board:calculateMatches()

    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()

        -- add score for each match
        for k, match in pairs(matches) do
            -- increase the timer and score based on the variety
            for k, tile in pairs(match) do
                self.score = self.score + tile.variety * 50
                self.timer = self.timer + tile.variety * 1
                if tile.shiny then
                    tile:destroy()
                end
            end
        end
        -- wait 25 ms before removal
        Timer.after(0.25, function()
            -- remove any tiles that matched from the board, making empty spaces
            self.board:removeMatches()

            -- gets a table with tween values for tiles that should now fall
            local tilesToFall = self.board:getFallingTiles()

            -- tween new tiles that spawn from the ceiling over 0.25s to fill in
            -- the new upper gaps that exist
            Timer.tween(0.25, tilesToFall):finish(function()
                local matches = self.board:calculateMatches()

                -- recursively call function in case new matches have been created
                -- as a result of falling blocks once new blocks have finished falling
                self:calculateMatches(matches)
            end)
        end)

        -- if no matches, we can continue playing
    else
        self.canInput = true
    end
end

function PlayState:render()
    -- render board of tiles
    self.board:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96 / 255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + BOARD_START_X,
            (self.highlightedTile.gridY - 1) * 32 + BOARD_START_Y, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217 / 255, 87 / 255, 99 / 255, 1)
    else
        love.graphics.setColor(172 / 255, 50 / 255, 50 / 255, 1)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + BOARD_START_X,
        self.boardHighlightY * 32 + BOARD_START_Y, 32, 32, 4)

    -- draw hint rectangle
    if self.showHint then
        love.graphics.setLineWidth(4)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('line', (self.hintHighlight.x - 1) * 32 + BOARD_START_X,
            (self.hintHighlight.y - 1) * 32 + BOARD_START_Y, 32, 32, 4)
    end

    -- GUI text
    love.graphics.setColor(56 / 255, 56 / 255, 56 / 255, 234 / 255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99 / 255, 155 / 255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end
