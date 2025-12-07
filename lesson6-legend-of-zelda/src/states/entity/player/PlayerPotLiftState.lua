--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    -- send signal
    Event.dispatch('pot-lift')

    self.player = player
    self.dungeon = dungeon
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.player.offsetY = 5
    self.player.offsetX = 0

    local direction = self.player.direction

    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerPotLiftState:update(dt)
    
     -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        if self.player.pickedObject and self.player.pickedObject.type == 'pot' then
            self.player:changeState('pot-lift-idle')
        else
            self.player:changeState('idle')
        end 
    end

    if self.player.pickedObject and self.player.pickedObject.type == 'pot' then
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
                self.player:changeState('pot-walk')
        end
    end

end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

end


