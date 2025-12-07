--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotLiftIdleState = Class{__includes = BaseState}

function PlayerPotLiftIdleState:init(player, dungeon)
    -- send signal

    self.player = player
    self.dungeon = dungeon
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.player.offsetY = 5
    self.player.offsetX = 0

    local direction = self.player.direction

    self.player:changeAnimation('pot-lift-idle-' .. self.player.direction)
end

function PlayerPotLiftIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.player:changeState('pot-walk')
    end

    -- pot throw state
    if  love.keyboard.wasPressed('return') then
        Event.dispatch('pot-throw')
        self.player:changeState('idle')
    end

end

function PlayerPotLiftIdleState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

end


