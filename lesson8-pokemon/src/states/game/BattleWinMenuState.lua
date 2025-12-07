--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleWinMenuState = Class{__includes = BaseState}

BattleWinMenuState.NAME = "BattleWinMenuState"

function BattleWinMenuState:init(battleWinState, onClose)
    self.battleWinState = battleWinState
    
    -- function to be called once this message is popped
    self.onClose = onClose or function() end
    
    self.battleWinMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        noSelection = true,
        items = {
            {
                text = 'HP ' .. self:calculateStats("hp"),
                onSelect = function()
                    gStateStack:pop()
                    self.onClose()
                end
            },
            {
                text = 'ATK ' .. self:calculateStats("atk")
            },
             {
                text = 'DEF ' .. self:calculateStats("def"),
            },
             {
                text = 'SPD ' .. self:calculateStats("spd"),
            },
        }
    }
end

function BattleWinMenuState:calculateStats(stat)
    return (self.battleWinState.stats[stat] - self.battleWinState.increase[stat]) .. 
    '+' .. self.battleWinState.increase[stat] .. '= ' ..  self.battleWinState.stats[stat]
end

function BattleWinMenuState:update(dt)
    self.battleWinMenu:update(dt)
end

function BattleWinMenuState:render()
    self.battleWinMenu:render()
end