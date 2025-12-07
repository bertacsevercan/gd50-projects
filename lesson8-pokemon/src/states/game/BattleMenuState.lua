--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMenuState = Class{__includes = BaseState}

BattleMenuState.NAME = "BattleMenuState"

function BattleMenuState:init(battleState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.playerPokemon
    self.opponentPokemon = self.battleState.opponentPokemon

    local items = {
            {
                text = 'Fight',
                onSelect = function()
                    gStateStack:pop()
                    gStateStack:push(TakeTurnState(self.battleState))
                end
            },
            {
                text = 'Run',
                onSelect = function()
                    local roll6 = math.random(6)
                    local escapeChance = 2

                    -- based on the opponent level, chance to escape differs..
                    if self.opponentPokemon.level > self.playerPokemon.level then
                        escapeChance = 4
                    elseif self.opponentPokemon.level == self.playerPokemon.level then
                        escapeChance = 3
                    end

                    if roll6 < escapeChance then
                        gSounds['hit']:play()

                        gStateStack:push(BattleMessageState("You couldn't escape..."))
                        return;
                    end

                    gSounds['run']:play()
                    
                    -- pop battle menu
                    gStateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    gStateStack:push(BattleMessageState('You fled successfully!',
                        function() end, false))
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 1, g = 1, b = 1
                        }, 1,
                        
                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state
                            gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            }
    }

    
    local menuItemCatch = {
            text = 'Catch',
            onSelect = function()
                gStateStack:pop()
                gStateStack:push(BattleInventoryMenuState(self.battleState))
            end
    }

    if not self.battleState.opponent.isNpc then
        table.insert(items, menuItemCatch)
    end
    
    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        font = gFonts['medium'],
        items = items
    }
end

function BattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function BattleMenuState:render()
    self.battleMenu:render()
end