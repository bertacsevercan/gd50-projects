--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
              -- save the player if they have hearts left
            if self.player.hearts > 0 then
                self.player.hearts = self.player.hearts - 1
                self.player:changeState('jump')
                Timer.after(0.2, function() 
                    gSounds['kill']:play()
                end)
            else
                gSounds['death']:play()
                gStateMachine:change('start')
            end
        end
    end
end