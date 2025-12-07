--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    self.health = def.health or 2
    self.broken = false
    
    self.consumable = def.consumable
    self.collidable = def.collidable

    self.animations = def.animations and self:createAnimations(def.animations) or false


    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
    self.onConsume = function() end
    self.onThrow = function() end

    self.projectile = def.projectile and Projectile(self) or false

end


function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:damage(dmg)
    self.health = self.health - dmg
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'tiles',
            frames = animationDef.frames,
            interval = animationDef.interval or 0.5
        }
    end

    return animationsReturned
end

function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function GameObject:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.projectile then
        self.projectile:update(dt)
    end

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    local anim = self.currentAnimation
    if anim then
        love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    else
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.state and self.states[self.state].frame or self.frame],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    end

--[[     love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255) ]]
end