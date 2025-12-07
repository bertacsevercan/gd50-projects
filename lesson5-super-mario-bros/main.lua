--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
    
    A classic platformer in the style of Super Mario Bros., using a free
    art pack. Super Mario Bros. was instrumental in the resurgence of video
    games in the mid-80s, following the infamous crash shortly after the
    Atari age of the late 70s. The goal is to navigate various levels from
    a side perspective, where jumping onto enemies inflicts damage and
    jumping up into blocks typically breaks them or reveals a powerup.

    Art pack:
    https://opengameart.org/content/kenney-16x16

    Music:
    https://freesound.org/people/Sirkoto51/sounds/393818/
]]
--[[ 
TODO:
-x Program it such that when the player is dropped into the level, they’re always done so above solid ground.

-x In LevelMaker.lua, generate a random-colored key and lock block 
(taken from keys_and_locks.png in the graphics folder of the distro).
The key should unlock the block when the player collides with it, triggering the block to disappear.
(I generate 4 keys to collect and render the picked keys)

-x Once the lock has disappeared, trigger a goal post to spawn at the end of the level.
 Goal posts can be found in flags.png; feel free to use whichever one you’d like! 
 Note that the flag and the pole are separated, so you’ll have to spawn a
 GameObject for each segment of the flag and one for the flag itself.
 (I spawn a gameobject as a pole and spawn an entity as the flag since its animated)

-x When the player touches this goal post, we should regenerate the level, 
 spawn the player at the beginning of it again (this can all be done via just reloading PlayState), 
 and make it a little longer than it was before. You’ll need to introduce params 
 to the PlayState:enter function that keeps track of the current level and persists
 the player’s score for this to work properly.
 (When the player unlocks the locks the camera moves to the flag and show that its up)

-x Add a camera pan to flag at start of level. 

-x Set player invincible when camera moves.

-x Camera pan is cancelable with 'enter'.

-x Add water tiles randomly spawned.

-x Fix the snail jitter when there's no room to move.

-x Fix the collision box of player, its too big.

-x Add red mushroom power-up for earning health. 
(Max heart is 3 and more than that adds to score)

-x Add health bars, using the hearts. 
(Player can't die unless hearts are depleted)

- Add a climbing state for climbing up the flag pole.

- Add a ladders for climbing for taller tile blocks.

- Add two new enemy types. 

- Add mushroom power-up for invincibility.

 ]]
love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/Dependencies'

function love.load()
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle('Super 50 Bros.')

    math.randomseed(os.time())
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end