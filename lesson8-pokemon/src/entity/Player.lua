--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.party = Party {
        pokemon = {
            Pokemon(Pokemon.getRandomDef(), 4),
           -- Pokemon(Pokemon.getRandomDef(), 2),
        }
    }

    self.inventory = Inventory {
        items = {
            Item("Pokeball", 2, "catch")
        }
    }
end