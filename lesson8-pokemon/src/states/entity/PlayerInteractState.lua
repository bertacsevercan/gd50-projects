--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerInteractState = Class{__includes = PlayerIdleState}

function PlayerInteractState:enter(params)
    self.interactObject = params
end

function PlayerInteractState:update(dt)
    -- call the "super" (parent) update first
    PlayerIdleState.update(self, dt)

    -- interact on 'enter'
    if love.keyboard.wasPressed('return') then
         if self.interactObject and self.interactObject.onInteract then
            self.interactObject:onInteract(self.entity)
        end
    end
end