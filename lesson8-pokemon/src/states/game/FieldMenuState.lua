--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FieldMenuState = Class{__includes = BaseState}

FieldMenuState.NAME = "FieldMenuState"

function FieldMenuState:init(level, onClose)
    self.level = level
    self.playerParty = self.level.player.party.pokemon

    self.onClose = onClose or function() end

    local items = {}

    for k, pokemon in pairs(self.playerParty) do
        items[k] = {
            text = pokemon.name .. " " .. pokemon.currentHP .. "HP " .. pokemon.level .. "LVL",
            onSelect = function()
                        gStateStack:pop()
                        self.onClose()
                    end
        }
    end

    self.fieldMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        font = gFonts['small'],
        items = items,
        noSelection = true
    }
    
end

function FieldMenuState:update(dt)
    self.fieldMenu:update(dt)
end

function FieldMenuState:render()
    self.fieldMenu:render()
end