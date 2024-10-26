local snow = { }
local snowflake = { }

function snowflake:new(direction)
    local o = { 
        x = love.math.random(0, 419),
        y = love.math.random(0, 319),
        size = love.math.random(1000, 1200) / 1000,
        speed = love.math.random(1000, 2200) / 1000,
        direction = direction
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function snowflake:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, 1 * self.size)

    self.x = self.x + self.speed * math.cos(self.direction)
    self.y = self.y + self.speed * math.sin(self.direction)

    if(self.x < 0) then self.x = 420 end
    if(self.x > 420) then self.x = 0 end

    if(self.y < 0) then self.y = 320 end
    if(self.y > 320) then self.y = 0 end
end

function snow:init()
    self.is_december = (tonumber(os.date("%m")) == 12)
    self.snowflakes = { }

    local direction = love.math.random(1000, 2141) / 1000
    for i=0,love.math.random(60,80),1 do
        table.insert(self.snowflakes, snowflake:new(direction))
    end
end

function snow:draw()
    if(not self.is_december) then return end
    for _, i in pairs(self.snowflakes) do i:draw() end
end

return snow