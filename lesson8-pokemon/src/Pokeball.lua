

Pokeball = Class{}

function Pokeball:init(x, y, color)
    self.x = x
    self.y = y
    self.radius = 10
    self.color = color or {r = 1, g = 0, b = 0}
end

function Pokeball:render()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle("fill", self.x, self.y, self.radius)   -- Draw circle 

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.x - self.radius, self.y, self.x + self.radius, self.y)
    love.graphics.circle("fill", self.x,self.y, (self.radius / 5))   -- Draw white circle and a line.
end