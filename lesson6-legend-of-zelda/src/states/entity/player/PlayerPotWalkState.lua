--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotWalkState = Class{__includes = EntityWalkState}

function PlayerPotWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.pot = player.pickedObject
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    local direction = self.entity.direction

    self.entity:changeAnimation('pot-walk-' .. self.entity.direction)
end

function PlayerPotWalkState:update(dt)
    
    self.pot.y = self.entity.y - TILE_SIZE

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')

        self.pot.x = self.entity.x - self.entity.walkSpeed * dt

    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')

        self.pot.x = self.entity.x + self.entity.walkSpeed * dt

    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')

        self.pot.y = (self.entity.y - TILE_SIZE) - self.entity.walkSpeed * dt

    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')

        self.pot.y = (self.entity.y - TILE_SIZE) + self.entity.walkSpeed * dt

    else
        self.entity:changeState('pot-lift-idle')
    end

    if  love.keyboard.wasPressed('return') then
        -- throw state
        Event.dispatch('pot-throw')
        self.entity:changeState('idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
    
end

function PlayerPotWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

end


