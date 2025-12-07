--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker:init(numKeys ,collectedKeys, moveCamera)
    self.numKeys = numKeys
    self.collectedKeys = collectedKeys
    self.moveCamera = moveCamera or {}
end

function LevelMaker:generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    local water = math.random(8)

    local waterTile = false
    local emptyTile = false

    local lock = true
    local key = false
    local poleX = width - 2

    local locksX = {}
    local keysX = {}
    local skipLocksX = {}

    for i = 1, self.numKeys do 
        local randomLockX = math.random(width - 15)
        table.insert(locksX, randomLockX)
        table.insert(skipLocksX, randomLockX, randomLockX)

        table.insert(keysX, math.random(width - 15))
    end

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset ))
        end
        -- lay ground on locked x spots
        if skipLocksX[x] then
            tileID = TILE_ID_GROUND
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end      
        -- always lay ground tiles at the start
        elseif x < 3 then
            tileID = TILE_ID_GROUND
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end   

        -- put the ending pole    
        elseif x > width - 10 then 
            tileID = TILE_ID_GROUND
             for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
             end
            if x == poleX then
                local pole
                pole = GameObject {
                                        texture = 'poles',
                                        x = (x - 1) * TILE_SIZE,
                                        y = 3 * TILE_SIZE + 1,
                                        width =  16,
                                        height = 3 * 16,
                                        frame = math.random(#POLES),
                                        collidable = false,
                                        solid = false
                                    }
                                    table.insert(objects, pole)
            end
        -- chance to just be emptiness
        elseif math.random(7) == 1 and not waterTile then  
            tileID = TILE_ID_EMPTY
            emptyTile = true
                for y = 7, height do
                    table.insert(tiles[y],
                        Tile(x, y, tileID, nil, tileset, topperset ))
                end
        -- chance to be water 
        elseif math.random(7) == 1 and not emptyTile then
            waterTile = true
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset, water))
            end    
        else
            waterTile = false
            emptyTile = false
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset ))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset )
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset )
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)

                                elseif math.random(5) == 1 then
                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'mushrooms',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = 21, --MUSHROOMS[math.random(#MUSHROOMS)],
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.hearts = math.min(3, player.hearts + 1) 
                                            if player.hearts >= 3 then 
                                                player.score = player.score + 100
                                            end
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)

                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local blockHeight = 4

    for k, lockX in pairs(locksX) do
           table.insert(objects, 
                        GameObject {
                        texture = 'locks',
                        x = (lockX - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = KEYS_LOCKS[k],
                        collidable = true,
                        solid = true,
                        hit = false,
                        onCollide = function(obj)
                                if  self.collectedKeys[k] then
                                    for i, object in pairs(objects) do
                                        if object.texture == 'locks' and object.frame == k then
                                            table.remove(objects, i)
                                            if #self.collectedKeys == self.numKeys then
                                                self.moveCamera(width)

                                                local flag
                                                flag = Flag {
                                                    texture = 'flags',
                                                    x = (poleX - 1) * TILE_SIZE,
                                                    y = 15 * TILE_SIZE,
                                                    width = 16,
                                                    height = 16,
                                                    stateMachine = StateMachine {
                                                        ['idle'] = function() return FlagIdleState(self.tileMap, self.player, flag) end,
                                                        ['moving'] = function() return FlagMovingState(self.tileMap, self.player, flag) end,
                                                    }
                                                }
                                                flag:changeState('idle', {
                                                    wait = 1
                                                })

                                                Timer.tween(2.5, {
                                                    [flag] = {y = (4 - 2) * TILE_SIZE + 9}
                                                })
                                                Timer.after(2.2, function() 
                                                    gSounds['powerup-reveal']:play()
                                                end)

                                                table.insert(entities, flag)
                                            end
                                        end
                                    end
                                    gSounds['pickup']:play()
                                else
                                    gSounds['empty-block']:play()

                                end
                        end
                    }
                )


                table.insert(objects,
                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (keysX[k] - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                    -- maintain reference so we can set it to nil
                                    local key = GameObject {
                                        texture = 'keys',
                                        x = (keysX[k] - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = KEYS_LOCKS[k],
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 200                                            
                                            self.collectedKeys[k] = k
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, key)
                            
                                obj.hit = true
                            end
                        end
                    }
                )
    end

   
    

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end