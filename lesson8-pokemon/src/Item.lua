--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Item = Class{}

function Item:init(name, amount, action)
    self.name = name
    self.amount = amount
    self.action = action
end

function Item:use()
    self.amount = math.max(0, self.amount - 1)
end

function Item:update(dt)

end

function Item:render()

end