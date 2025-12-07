Powerup = Class {}

function Powerup:init(x, y, type)
    self.width = 16
    self.height = 16

    self.x = x
    self.y = y

    self.dy = math.random(50, 60)
    self.dx = math.random(-50, 50)

    self.type = type
    self.inPlay = true
    self.active = false
    self.types = {
        "Extra Heart", 
        "Lose Heart", 
        "Fast Paddle", 
        "Slow Paddle", 
        "Small Ball", 
        "Big Ball", 
        "Extra Ball", 
        "Treasure Key"
    }
end

function Powerup:effect(params)
    if self.type == 1 then
        self:extraHeart(params)
    elseif self.type == 2 then
        self:loseHeart(params)
        if params.health == 0 then
            gStateMachine:change('game-over', {
                score = params.score,
                highScores = params.highScores
            })
        end
    elseif self.type == 3 then
        self:fastPaddle()
    elseif self.type == 4 then
        self:slowPaddle()
    elseif self.type == 5 then
        self:smallBall(params.ball)
    elseif self.type == 6 then
        self:bigBall(params.ball)
    elseif self.type == 7 then
        self:extraBall(params)
    elseif self.type == 8 then
        self:treasureKey(params)
    end
    return self.types[self.type]
end

function Powerup:extraHeart(params)
    params.health = math.min(3, params.health + 1)
    gSounds['recover']:play()
end

function Powerup:loseHeart(params)
    params.health = params.health - 1
    gSounds['hurt']:play()
end

function Powerup:fastPaddle()
    PADDLE_SPEED = 300
end

function Powerup:slowPaddle(paddle)
    PADDLE_SPEED = 100
end

function Powerup:smallBall(balls)
    for k, ball in pairs(balls) do
        ball.width = math.max(4, ball.width / 2)
        ball.height = math.max(4, ball.height / 2)
    end
end

function Powerup:bigBall(balls)
    for k, ball in pairs(balls) do
        ball.width = math.min(16, ball.width * 2)
        ball.height = math.min(16, ball.height * 2)
    end
end

function Powerup:extraBall(params)
    local extraBall = Ball(math.random(7))
    extraBall.x = params.paddle.x + (params.paddle.width / 2) - 4
    extraBall.y = params.paddle.y - extraBall.width
    extraBall.dx = math.random(-200, 200)
    extraBall.dy = math.random(-100, -120)
    table.insert(params.ball, extraBall)
end

function Powerup:treasureKey(params)
    params.score = params.score + 2000
    params.hasKey = true
end

function Powerup:hit()
    self.inPlay = false
    gSounds['powerup']:play()
end


function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

     -- allow powerup to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        --gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        --gSounds['wall-hit']:play()
    end

    if self.y >= VIRTUAL_HEIGHT then
        self.inPlay = false
        --gSounds['wall-hit']:play()
    end
end

function Powerup:render()
    if self.inPlay then
        self.active = true
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type],
        self.x, self.y)
    end
end