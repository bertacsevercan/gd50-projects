--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

PlayState.NAME = "PlayState"

function PlayState:init()
    self.level = Level()

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()

    self.dialogueOpened = false
    self.fieldMenuOpened = false
end

function PlayState:healParty()
    for i = 1, #self.level.player.party.pokemon do
        self.level.player.party.pokemon[i].currentHP = self.level.player.party.pokemon[i].HP
    end
end

function PlayState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then
        
        -- heal player pokemon
        gSounds['heal']:play()

        --self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP
        self:healParty()
        self.level.player.inventory.items[1].amount = math.max(self.level.player.inventory.items[1].amount, 2)
        
        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(DialogueState('Your Pokemon has been healed and pokeballs replenished!',
    
        function()
            self.dialogueOpened = false
        end))
    end

    if not self.fieldMenuOpened and love.keyboard.wasPressed('m') then
        -- open field menu
        
        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(FieldMenuState(self.level,
        function()
            self.fieldMenuOpened = false
        end))
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end