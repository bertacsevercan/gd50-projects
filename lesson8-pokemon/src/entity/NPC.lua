--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

NPC = Class{__includes = Entity}

function NPC:init(def)
    Entity.init(self, def)

    -- text that will be 
    self.text = {
        "Hi, I'm an NPC, demonstrating some dialogue! Isn't that cool??", 
        "Wanna battle??"
    }

    self.textIndex = 1
    
    self.party = Party {
        pokemon = {
            Pokemon(Pokemon.getRandomDef(), 3),
            Pokemon(Pokemon.getRandomDef(), 2),
        }
    }

    self.direction = def.direction
end

--[[
    Function that will get called when we try to interact with this entity.
]]
function NPC:onInteract(params)
    if self.textIndex > #self.text then
        -- trigger music changes
            gSounds['field-music']:pause()
            gSounds['battle-music']:play()
            
            -- first, push a fade in; when that's done, push a battle state and a fade
            -- out, which will fall back to the battle state once it pushes itself off
            gStateStack:push(
                FadeInState({
                    r = 1, g = 1, b = 1,
                }, 1, 
                
                -- callback that will execute once the fade in is complete
                function()
                    gStateStack:push(BattleState(params, self))
                    gStateStack:push(FadeOutState({
                        r = 1, g = 1, b = 1,
                    }, 1,
                
                    function()
                        -- nothing to do or push here once the fade out is done
                    end))
                end)
            )
        self.textIndex = 1
        return
    end

    gStateStack:push(DialogueState(self.text[self.textIndex]))
    self.textIndex = self.textIndex + 1

end