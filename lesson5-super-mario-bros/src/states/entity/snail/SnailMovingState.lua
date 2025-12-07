--[[
    GD50
    Super Mario Bros. Remake

    -- SnailMovingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

SnailMovingState = Class{__includes = BaseState}

function SnailMovingState:init(tilemap, player, snail)
    self.tilemap = tilemap
    self.player = player
    self.snail = snail
    self.animation = Animation {
        frames = {49, 50},
        interval = 0.5
    }
    self.snail.currentAnimation = self.animation

    self.movingDirection = math.random(2) == 1 and 'left' or 'right'
    self.snail.direction = self.movingDirection
    self.movingDuration = math.random(5)
    self.movingTimer = 0
end

function SnailMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.snail.currentAnimation:update(dt)

    -- reset movement direction and timer if timer is above duration
    if self.movingTimer > self.movingDuration then

        -- chance to go into idle state randomly
        if math.random(4) == 1 then
            self.snail:changeState('idle', {

                -- random amount of time for snail to be idle
                wait = math.random(5)
            })
        else
            self.movingDirection = math.random(2) == 1 and 'left' or 'right'
            self.snail.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    elseif self.snail.direction == 'left' then
        self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the left or a solid tile directly left
        if self:checkLeft() then
            if not self:checkRight() then
                self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt
                -- reset direction if we hit a wall
                self.movingDirection = 'right'
                self.snail.direction = self.movingDirection
                self.movingDuration = math.random(5)
                self.movingTimer = 0
            else
                 self.snail:changeState('idle', {

                -- random amount of time for snail to be idle
                wait = math.random(5)
            })
            end
        end
    else
        self.snail.direction = 'right'
        self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt

        -- stop the snail if there's a missing tile on the floor to the right or a solid tile directly right
        

        if  self:checkRight() then
            if not self:checkLeft() then 

                self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

                -- reset direction if we hit a wall
                self.movingDirection = 'left'
                self.snail.direction = self.movingDirection
                self.movingDuration = math.random(5)
                self.movingTimer = 0
            else
                 self.snail:changeState('idle', {

                -- random amount of time for snail to be idle
                wait = math.random(5)
            })
            end
        end
    end

    -- calculate difference between snail and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.snail.x)

    if diffX < 5 * TILE_SIZE then
        self.snail:changeState('chasing')
    end
end

function SnailMovingState:checkLeft()
    local tileLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y)
    local tileBottomLeft = self.tilemap:pointToTile(self.snail.x + 3, self.snail.y + self.snail.height)

    local result = (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable())
    return  result
end

function SnailMovingState:checkRight()
    local tileRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
    local tileBottomRight = self.tilemap:pointToTile(self.snail.x - 3 + self.snail.width, self.snail.y + self.snail.height)

    local result = (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable())
    return  result
end