--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        consumable = true
    },
    ['pot'] = {
        -- TODO
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        health = 26 * 2,
        projectile = true,
        solid = true,
        collidable = true,
        defaultState = 'empty',
        states = {
            ['empty'] = {
                frame = 14
            },
            ['full'] = {
                frame =  33
            },
            ['broken'] = {
                frame = 52
            },
        },
        animations = {
            ['empty'] = {
                frames = {14, 15, 16},
            },
            ['full'] = {
                frames = {33, 34, 35},
            },
            ['broken'] = {
                frames = {52, 53, 54},
            },
        }
    }
}