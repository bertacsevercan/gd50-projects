--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params, dt)
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state)
    table.insert(self.states, state)
    print("PUSH - #" .. #self.states)
    print(state.NAME, state.msg or "")
    state:enter()
end

function StateStack:pop()
    self.states[#self.states]:exit()
    local state = table.remove(self.states)
    print("POP - #" .. #self.states)
    print(state.NAME, state.msg or "")
end