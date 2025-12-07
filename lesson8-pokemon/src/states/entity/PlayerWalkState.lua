--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, level)
    EntityWalkState.init(self, entity, level)
    self.encounterFound = false
    self.npc = self.level.npc
end

function PlayerWalkState:enter()
    self:checkForEncounter()

    if not self.encounterFound then
        self:attemptMove(self.npc)
    end
end


function PlayerWalkState:checkForEncounter()
    local x, y = self.entity.mapX, self.entity.mapY

    local roll10 = math.random(10)

    -- chance to go to battle if we're walking into a grass tile, else move as normal
    if self.level.grassLayer.tiles[y][x].id == TILE_IDS['tall-grass'] then
        -- roll for battle encounter
        if roll10 == 1 then
            self.entity:changeState('idle')

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
                    gStateStack:push(BattleState(self.entity))
                    gStateStack:push(FadeOutState({
                        r = 1, g = 1, b = 1,
                    }, 1,
                
                    function()
                        -- nothing to do or push here once the fade out is done
                    end))
                end)
            )
            self.encounterFound = true
        end

        -- roll for finding an item: only pokeball 
        if self.entity.inventory.items[1].amount < 5 and roll10 == 2 then
            self.entity:changeState('idle')
            gSounds['heal']:play()

            local item = self.entity.inventory.items[1]
            item.amount = item.amount + 1
            gStateStack:push(DialogueState('Found an item: ' .. item.name .. '! Total: ' .. item.amount ))
            self.encounterFound = true
        end
    else
        self.encounterFound = false
    end
end