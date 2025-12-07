--[[
    GD50
    Super Mario Bros. Remake

    -- Snail Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Flag = Class{__includes = Entity}

function Flag:init(def)
    Entity.init(self, def)
   -- self.frame = def.frame
end

function Flag:render()
   --[[  love.graphics.draw(gTextures['poles'], gFrames['poles'][self.frame],
        math.floor(self.x) + 8, math.floor(self.y) + 8) ]]

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 9, math.floor(self.y) + 8)
end