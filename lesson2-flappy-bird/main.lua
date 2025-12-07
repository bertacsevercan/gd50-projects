push = require 'lib.push'
Class = require 'lib.class'

require 'classes/Bird'
require 'classes/Pipe'
require 'classes/PipePair'
require 'classes/StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- local scope
local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local pipePairs = {}
local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local paused = false

-- TODO:
-- add medal system x
-- add pause game feature x
-- Randomize the gap between pipes (vertical space), such that they’re no longer hardcoded to 90 pixels. x
-- Randomize the interval at which pairs of pipes spawn, such that they’re no longer always 2 seconds apart. x
-- bonus: add a commenter emoji guy ?

function love.load()
    -- no blur
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set title
    love.window.setTitle('Flippy Bird')

    -- fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- init table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['lose'] = love.audio.newSource('sounds/fart.mp3', 'static'),
        ['win'] = love.audio.newSource('sounds/clap.mp3', 'static'),
        ['pause'] = love.audio.newSource('sounds/duff.mp3', 'static'),
        ['hurt'] = love.audio.newSource('sounds/roblox.mp3', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:setVolume(0.2)
    sounds['music']:play()


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- g letter means its global, good practice!!
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    math.randomseed(os.time())

    -- custom table defined in love.keyboard
    love.keyboard.keysPressed = {}
end

-- scales the virtual canvas on push
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

    if gStateMachine.activeState == 'play' and (key == 'enter' or key == 'return') then
        paused = not paused

        if paused then
            sounds['pause']:play()
            sounds['music']:pause()
        else
            sounds['music']:play()
        end
    end
end

-- custom function to check if a key pressed once
-- similar to love.keypressed but we don't wanna override it
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if not paused then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gStateMachine:update(dt)
    end

    -- reset the input table at every update
    -- so it's not always true
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    -- draw the sprites and position it
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    -- show pause message
    if paused then
        love.graphics.printf('Paused', 0, 100, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
