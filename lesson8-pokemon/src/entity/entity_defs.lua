--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player'] = {
        animations = {
            ['walk-left'] = {
                frames = {16, 17, 18, 17},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-right'] = {
                frames = {28, 29, 30, 29},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-down'] = {
                frames = {4, 5, 6, 5},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-up'] = {
                frames = {40, 41, 42, 41},
                interval = 0.15,
                texture = 'entities'
            },
            ['idle-left'] = {
                frames = {17},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {29},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'entities'
            },
            ['idle-up'] = {
                frames = {41},
                texture = 'entities'
            },
        }
    },
    ['npc'] = {
        animations = {
            ['walk-left'] = {
                frames = {19, 20, 21, 20},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-right'] = {
                frames = {31, 32, 33, 32},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-down'] = {
                frames = {7, 8, 9, 8},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-up'] = {
                frames = {43, 44, 45, 44},
                interval = 0.15,
                texture = 'entities'
            },
            ['idle-left'] = {
                frames = {19},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {31},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {7},
                texture = 'entities'
            },
            ['idle-up'] = {
                frames = {43},
                texture = 'entities'
            },
        }
    }
}