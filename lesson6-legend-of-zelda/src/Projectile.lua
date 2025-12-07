--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(object)
    self.object = object
    self.velocity = 0
end

function Projectile:throw(direction, velocity, entities)
    -- make sure it runs only once
    if self.hasThrown then
        return
    end
    self.hasThrown = true

    self.direction = direction
    self.velocity = velocity
    self.startingX = self.object.x
    self.startingY = self.object.y
    self.entities = entities

    if direction == 'left' then
        self.object.x = self.object.x - self.object.width
        self.object.y = self.object.y + self.object.height + 2
    elseif direction == 'right' then
        self.object.x = self.object.x + self.object.width
        self.object.y = self.object.y + self.object.height + 2
    elseif direction == 'up' then
        self.object.y = self.object.y - self.object.height
    else
        self.object.y = self.object.y + self.object.height
    end
end

function Projectile:update(dt)

    -- hit other entities
    if self.entities then 
        for k, entity in pairs(self.entities) do
            if entity:collides(self.object) then
                entity:damage(1)
                gSounds['hit-enemy']:play()
            end
        end 
    end

    -- break the object after 4 tiles
    if self.startingX and self.startingY then
        if math.abs(self.object.x - self.startingX) >= 4 * TILE_SIZE 
        or math.abs(self.object.y - self.startingY) >= 4 * TILE_SIZE then
                self.object:damage(100)
                self.velocity = 0
        end
    end

    if self.direction == 'left' then
        self.object.x = self.object.x  - self.velocity * dt

        if self.object.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.object.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.object:damage(100)
            self.velocity = 0
        end
    elseif self.direction == 'right' then
        self.object.x = self.object.x + self.velocity * dt

         if self.object.x + self.object.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.object.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.object.width
            self.object:damage(100)
            self.velocity = 0
        end
    elseif self.direction == 'up' then
        self.object.y = self.object.y - self.velocity * dt

        if self.object.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.object.height / 2 then 
            self.object.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.object.height / 2
            self.object:damage(100)
            self.velocity = 0
        end
    elseif self.direction == 'down' then
        self.object.y = self.object.y + self.velocity * dt

        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.object.y + self.object.height >= bottomEdge then
            self.object.y = bottomEdge - self.object.height
            self.object:damage(100)
            self.velocity = 0
        end
    else
        self.velocity = 0
    end

end

function Projectile:render()

end