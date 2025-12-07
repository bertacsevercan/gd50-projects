--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class {}

function Tile:init(x, y, color, variety, shiny)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny = shiny

    -- particle system belonging to the tile, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- lasts between 0.5-1 seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setEmissionArea('normal', 10, 10)
end

function Tile:destroy()
    self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    self.psystem:emit(64)
end

function Tile:update(dt)
    self.psystem:update(dt)
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34 / 255, 32 / 255, 52 / 255, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.shiny then
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', self.x + x, self.y + y, 32, 32, 4)
    end
end

function Tile:renderParticles(x, y)
    love.graphics.draw(self.psystem, self.x + x, self.y + y)
end
