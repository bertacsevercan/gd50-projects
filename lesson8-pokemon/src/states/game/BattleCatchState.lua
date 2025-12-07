--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleCatchState = Class{__includes = BaseState}

BattleCatchState.NAME = "BattleCatchState"

function BattleCatchState:init(battleState)
    self.battleState = battleState
    self.opponentCircleX = 50
    self.opponentCircleY = 60

    self.catchStarted = false

    self.pokeball = Pokeball(self.opponentCircleX, self.opponentCircleY)

    -- references to active pokemon
    self.playerPokemon = self.battleState.playerPokemon
    self.opponentPokemon = self.battleState.opponentPokemon

    self.opponentSprite = self.battleState.opponentSprite

end

function BattleCatchState:enter(params)
    gSounds['hit']:play()
end

function BattleCatchState:exit()
    -- gSounds['battle-music']:stop()
    -- gSounds['field-music']:play()
end

function BattleCatchState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.catchStarted then
        self:triggerSlideIn()
    end
end

function BattleCatchState:render()
    if self.catchStarted then
        self.pokeball:render()
    end
end


function BattleCatchState:triggerSlideIn()
    self.catchStarted = true

    -- display a dialogue first for the pokemon that appeared, then the one being sent out
    gStateStack:push(BattleMessageState('Used a ' .. self.battleState.player.inventory.items[1].name ..
        '!',  function() end, false))

    -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
    Timer.tween(1, {
        [self.pokeball] = {x = VIRTUAL_WIDTH - 100}
    })
    :finish(function()
        -- pop previous message
        gStateStack:pop()

        self:triggerCatch()
    end)
end

function BattleCatchState:rollForCatch() 
    -- increase the number of dices rolled based on two things: level and hp
    local diceCount = 1
    if self.opponentPokemon.level <= self.playerPokemon.level then
        diceCount = diceCount + 1
    end

    if self.opponentPokemon.currentHP < (self.opponentPokemon.HP / 2) then
        diceCount = diceCount + 1
    end

    for i = 1, diceCount do
        local roll = math.random(6)
        if roll > 4 then
            return true
        end    
    end
    return false
end

function BattleCatchState:triggerCatch()
    local caught = self:rollForCatch()

    -- blink the attacker sprite three times (turn on and off blinking 6 times)
    Timer.every(0.1, function()
        self.opponentSprite.opacity = self.opponentSprite.opacity == 64/255 and 1 or 64/255
    end)
    :limit(6)
    :finish(function()
        if caught then
            -- put the caught pokemon to party
            self.battleState.player.party:addPokemon(self.opponentPokemon)

            self.opponentSprite.opacity = 0

            gStateStack:push(BattleMessageState(self.opponentPokemon.name .. ' caught succesfully!', 
            function()
                -- pop off the battle catch state
                gStateStack:pop()

                -- fade in
                gStateStack:push(FadeInState({
                    r = 1, g = 1, b = 1
                }, 1, 
                function()
                    -- resume field music
                    gSounds['battle-music']:stop()
                    gSounds['field-music']:play()
                    
                    -- pop off the battle state
                    gStateStack:pop()
                    gStateStack:push(FadeOutState({
                        r = 1, g = 1, b = 1
                    }, 1, function() end))
                end))
            
            end))                               

        else
            gStateStack:push(BattleMessageState(self.opponentPokemon.name .. ' got away!', 
            function()
                -- pop off the battle catch state
                gStateStack:pop()

                self.catchStarted = false

                gStateStack:push(BattleMenuState(self.battleState))
            end))
        end
    end)
end

