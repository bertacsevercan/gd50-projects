--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleNextPlayerState = Class{__includes = BaseState}

BattleNextPlayerState.NAME = "BattleNextPlayerState"

function BattleNextPlayerState:init(battleState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.playerPokemon

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false

    self.playerSprite = BattleSprite(self.playerPokemon.battleSpriteBack, 
        -64, VIRTUAL_HEIGHT - 128)

    self.battleState.playerSprite = self.playerSprite
    
    -- health bars for pokemon
    self.playerHealthBar = ProgressBar {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 80,
        width = 152,
        height = 6,
        color = {r = 189/255, g = 32/255, b = 32/255},
        value = self.playerPokemon.currentHP,
        max = self.playerPokemon.HP
    }

    self.battleState.playerHealthBar = self.playerHealthBar

    -- exp bar for player
    self.playerExpBar = ProgressBar {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 73,
        width = 152,
        height = 6,
        color = {r = 32/255, g = 32/255, b = 189/255},
        value = self.playerPokemon.currentExp,
        max = self.playerPokemon.expToLevel
    }

    self.battleState.playerExpBar = self.playerExpBar

    -- flag for rendering health (and exp) bars, shown after pokemon slide in
    self.renderHealthBars = false
end

function BattleNextPlayerState:enter(params)
    
end

function BattleNextPlayerState:exit()
    -- gSounds['battle-music']:stop()
    -- gSounds['field-music']:play()
end

function BattleNextPlayerState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.battleStarted then
        self:triggerSlideIn()
    end
end

function BattleNextPlayerState:render()
    love.graphics.setColor(1, 1, 1, 1)
   
    self.playerSprite:render()

    if self.renderHealthBars then
        self.playerHealthBar:render()
        self.playerExpBar:render()

        -- render level text
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(gFonts['small'])
        love.graphics.print('LV ' .. tostring(self.playerPokemon.level),
            self.playerHealthBar.x, self.playerHealthBar.y - 10)
       
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(1, 1, 1, 1)
    end

end

function BattleNextPlayerState:triggerSlideIn()
    self.battleStarted = true

    -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
    Timer.tween(1, {
        [self.playerSprite] = {x = 32},
    })
    :finish(function()
        self:triggerStartingDialogue()
        self.renderHealthBars = true
    end)
end

function BattleNextPlayerState:triggerStartingDialogue()
    
    gStateStack:push(BattleMessageState('Go, ' .. tostring(self.playerPokemon.name .. '!'),    
    -- push a battle menu onto the stack that has access to the battle state
    function()
        -- pop off the battle next player state
        gStateStack:pop()

        gStateStack:push(BattleMenuState(self.battleState))
    end))
end