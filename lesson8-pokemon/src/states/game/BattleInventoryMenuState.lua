--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleInventoryMenuState = Class{__includes = BaseState}

BattleInventoryMenuState.NAME = "BattleInventoryMenuState"

function BattleInventoryMenuState:init(battleState)
    self.battleState = battleState
    self.playerInventory = self.battleState.player.inventory.items
    self.playerParty = self.battleState.player.party.pokemon
    local maxParty = 3

    local items = {}

     for k, item in pairs(self.playerInventory) do
        items[k] = 
        {
            text = item.amount .. " x " .. item.name,
            onSelect = 
                function()
                    gStateStack:pop()

                    -- if no item left go back to previous menu
                    if item.amount > 0 then
                        item:use()

                        if item.action == "catch" then
                            if #self.playerParty >= maxParty then
                                gStateStack:push(BattleMessageState("Party full! Max party: " .. maxParty, function()
                                    gStateStack:push(BattleMenuState(self.battleState))
                                end))
                            else
                                gStateStack:push(BattleCatchState(self.battleState))
                            end
                        end
                    else
                        gStateStack:push(BattleMenuState(self.battleState))
                    end
                end
        }
    end
    
    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        font = gFonts['small'],
        items = items
    }
end

function BattleInventoryMenuState:update(dt)
    self.battleMenu:update(dt)
end

function BattleInventoryMenuState:render()
    self.battleMenu:render()
end