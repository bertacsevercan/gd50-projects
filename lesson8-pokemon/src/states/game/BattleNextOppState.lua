--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleNextOppState = Class{__includes = BaseState}

BattleNextOppState.NAME = "BattleNextOppState"

function BattleNextOppState:init(battleState)
    self.battleState = battleState
    self.opponentPokemon = self.battleState.opponentPokemon

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false

    self.opponentSprite = BattleSprite(self.opponentPokemon.battleSpriteFront, 
        VIRTUAL_WIDTH, 8)

    self.battleState.opponentSprite = self.opponentSprite
    
    -- health bars for pokemon
     self.opponentHealthBar = ProgressBar {
        x = 8,
        y = 8,
        width = 152,
        height = 6,
        color = {r = 189/255, g = 32/255, b = 32/255},
        value = self.opponentPokemon.currentHP,
        max = self.opponentPokemon.HP
    }

    self.battleState.opponentHealthBar = self.opponentHealthBar

    -- flag for rendering health (and exp) bars, shown after pokemon slide in
    self.renderHealthBars = false
end

function BattleNextOppState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.battleStarted then
        self:triggerSlideIn()
    end
end

function BattleNextOppState:render()
    love.graphics.setColor(1, 1, 1, 1)
   
    self.opponentSprite:render()

    if self.renderHealthBars then
        self.opponentHealthBar:render()

        -- render level text
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(gFonts['small'])
        love.graphics.print('LV ' .. tostring(self.opponentPokemon.level),
            self.opponentHealthBar.x, self.opponentHealthBar.y - 10)
       
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(1, 1, 1, 1)
    end

end

function BattleNextOppState:triggerSlideIn()
    self.battleStarted = true

    -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
    Timer.tween(1, {
        [self.opponentSprite] = {x = VIRTUAL_WIDTH - 96},
    })
    :finish(function()
        self:triggerStartingDialogue()
        self.renderHealthBars = true
    end)
end

function BattleNextOppState:triggerStartingDialogue()
    
    gStateStack:push(BattleMessageState('Opponent sends ' .. tostring(self.opponentPokemon.name .. '!'),    
    -- push a battle menu onto the stack that has access to the battle state
    function()
        -- pop off the battle next player state
        gStateStack:pop()

        gStateStack:push(BattleMenuState(self.battleState))
    end))
end