--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

local BRONZE_SCORE = 5
local SILVER_SCORE = 10
local GOLD_SCORE = 15

local LOST_IMAGE = love.graphics.newImage('images/puke.png')
local BRONZE_IMAGE = love.graphics.newImage('images/medals_bronze.png')
local SILVER_IMAGE = love.graphics.newImage('images/medals_silver.png')
local GOLD_IMAGE = love.graphics.newImage('images/medals_gold.png')

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.medalMessage = "Oof! You suck!"
    self.medalImage = LOST_IMAGE

    sounds['music']:stop()

    -- check win condition
    if self.score >= GOLD_SCORE then
        sounds['win']:play()
        self.medalMessage = "Wow! That's Golden!"
        self.medalImage = GOLD_IMAGE
    elseif self.score >= SILVER_SCORE then
        sounds['win']:play()
        self.medalMessage = "Nice! Silver performance!"
        self.medalImage = SILVER_IMAGE
    elseif self.score >= BRONZE_SCORE then
        sounds['win']:play()
        self.medalMessage = "Heh! Not bad for Bronze!"
        self.medalImage = BRONZE_IMAGE
    else
        sounds['lose']:play()
    end

   
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf(self.medalMessage, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(self.medalImage, VIRTUAL_WIDTH / 2 - 30, 120,
     0, 0.5, 0.5)

    love.graphics.printf('Press Enter to Play Again!', 0, 190, VIRTUAL_WIDTH, 'center')
end