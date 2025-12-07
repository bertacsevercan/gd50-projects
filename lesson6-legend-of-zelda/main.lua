--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

--[[
TODO:
-x Implement hearts that sometimes drop from enemies at random,
which will heal the player for a full heart when picked up (consumed).

-x Add pots to the game world (from the tile sheet) at random that the player can pick up,
 at which point their animation will change to reflect them carrying the pot
 (shown in the character sprite sheets).
 The player should not be able to swing their sword when in this state.

-x When carrying a pot, the player should be able to throw the pot.
 When thrown, the pot will travel in a straight line based on where the player is looking.
 When it collides with a wall, travels more than four tiles, or collides with an enemy,
 it should disappear. When it collides with an enemy, it should do 1 point of damage to that enemy as well.

Additions:
-x Pot can be broken with an attack, and it can be contain a heart, it doesn't disappear after broken
-x When pot hits something, it can break.
-x Pot has some health, so it doesn't break right away.

- Add a random boss to the dungeon.
 ]]
require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Legend of Zelda')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
