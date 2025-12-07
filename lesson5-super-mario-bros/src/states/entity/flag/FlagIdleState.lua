--[[
    GD50
    Super Mario Bros. Remake

    -- FlagIdleState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FlagIdleState = Class{__includes = BaseState}

function FlagIdleState:init(tilemap, player, flag)
    self.tilemap = tilemap
    self.player = player
    self.flag = flag
    self.waitTimer = 0
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.flag.currentAnimation = self.animation
end

function FlagIdleState:enter(params)
    self.waitPeriod = params.wait
end

function FlagIdleState:update(dt)
    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt
    else
        self.flag:changeState('moving')
    end
end