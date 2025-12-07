Bird = Class{}

-- the less it is, the slower it falls
local GRAVITY = 20
local ANTI_GRAVITY = -5

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    -- get the size dynamically with the built in methods
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- put it in the middle and shift it
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    -- AABB collision detection, checking the corners of the 
    -- the offset is make the collision box a bit smaller 
    -- so that it's harder to lose the game
    -- which makes the game easier
    if (self.x + 4) + (self.width - 8) >= pipe.x and self.x + 4 <= pipe.x + PIPE_WIDTH then
        if (self.y + 4) + (self.height - 8) >= pipe.y and self.y + 4 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = ANTI_GRAVITY
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
    
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, 0)
end


