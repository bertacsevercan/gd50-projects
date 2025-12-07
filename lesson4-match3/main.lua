--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Match-3 has taken several forms over the years, with its roots in games
    like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
    version of this game, as well as Candy Crush from 2012, though all these
    games owe Shariki, a DOS game from 1994, for their inspiration.

    The goal of the game is to match any three tiles of the same variety by
    swapping any two adjacent tiles; when three or more tiles match in a line,
    those tiles add to the player's score and are removed from play, with new
    tiles coming from the ceiling to replace them.

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

--[[ TODO:

-x Fix setColor bug.

-x Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match.

-x Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet),
with later levels generating the blocks with patterns on them (like the triangle, cross, etc.).
These should be worth more points, at your discretion.
(I introduced a new color after every 3 level and a new variety after every 4 level).

-x Create random shiny versions of blocks that will destroy an entire row on match,
granting points for each block in the row.

-x Only allow swapping when it results in a match.
If there are no matches available to perform, reset the board.

-x (Optional) Implement matching using the mouse.

-x Add a particle effect on shiny match.

-x Add a hint feature if player's stuck.
Hint is only for 3 moves at most.

-x Add tile variety check for a match, not just color.
 ]]

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 80

BOARD_START_X = VIRTUAL_WIDTH - 272
BOARD_START_Y = 16

function love.load()
    -- window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
    love.mouse.clicked = {}
    love.mouse.position = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousemoved(x, y)
    local virtX, virtY = push:toGame(x, y)
    love.mouse.position = { ['x'] = virtX, ["y"] = virtY }
end

function love.mouse.getCurrentPos()
    return love.mouse.position
end

function love.mousepressed(x, y, button)
    local virtX, virtY = push:toGame(x, y)
    love.mouse.clicked[button] = { ['x'] = virtX, ["y"] = virtY }
end

function love.mouse.wasClicked(button)
    if love.mouse.clicked[button] then
        return love.mouse.clicked[button]
    else
        return false
    end
end

function love.update(dt)
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.clicked = {}
    love.mouse.position = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)

    gStateMachine:render()
    push:finish()
end
