--[[
    GD50
    Super Mario Bros. Remake

    -- FlagMovingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FlagMovingState = Class{__includes = BaseState}

function FlagMovingState:init(tilemap, player, flag)
    self.tilemap = tilemap
    self.player = player
    self.flag = flag
    self.animation = Animation {
        frames = {1, 2},
        interval = 0.3
    }
    self.flag.currentAnimation = self.animation
    self.movingDuration = 5
    self.movingTimer = 0
end

function FlagMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.flag.currentAnimation:update(dt)

    -- reset movement direction and timer if timer is above duration
    if self.movingTimer > self.movingDuration then
        self.flag:changeState('idle', {
            wait = math.random(5)
        })
    end
end