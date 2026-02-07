local Player = {}
Player.__index = Player

function Player.new(x, y)
    return setmetatable({
        x = x,
        y = y,
        radius = 14,
        speed = 170,
        hp = 5,
        attackCooldown = 0.35,
        attackTimer = 0,
        attackRange = 45,
        attackActiveTime = 0.08,
        attackActiveTimer = 0,
        attackDamage = 1,
        facingX = 1,
        facingY = 0,
        hitCooldown = 0.6,
        hitTimer = 0
    }, Player)
end

local function getMoveInput()
    local dx, dy = 0, 0

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dx = dx - 1
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dx = dx + 1
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        dy = dy - 1
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dy = dy + 1
    end

    return dx, dy
end

function Player:update(dt)
    local dx, dy = getMoveInput()
    local len = math.sqrt(dx * dx + dy * dy)

    if len > 0 then
        dx, dy = dx / len, dy / len
        self.x = self.x + dx * self.speed * dt
        self.y = self.y + dy * self.speed * dt
        self.facingX, self.facingY = dx, dy
    end

    local w, h = love.graphics.getDimensions()
    self.x = math.max(self.radius, math.min(w - self.radius, self.x))
    self.y = math.max(self.radius, math.min(h - self.radius, self.y))

    self.attackTimer = math.max(0, self.attackTimer - dt)
    self.attackActiveTimer = math.max(0, self.attackActiveTimer - dt)
    self.hitTimer = math.max(0, self.hitTimer - dt)

    if love.keyboard.isDown("space") and self.attackTimer <= 0 then
        self.attackTimer = self.attackCooldown
        self.attackActiveTimer = self.attackActiveTime
    end
end

function Player:isAttackActive()
    return self.attackActiveTimer > 0
end

function Player:getAttackCenter()
    return self.x + self.facingX * self.attackRange, self.y + self.facingY * self.attackRange
end

function Player:takeDamage(amount)
    if self.hitTimer > 0 then
        return false
    end

    self.hp = self.hp - amount
    self.hitTimer = self.hitCooldown
    return self.hp > 0
end

function Player:draw()
    if self.hitTimer > 0 then
        love.graphics.setColor(1, 0.6, 0.6)
    else
        love.graphics.setColor(0.4, 0.8, 1)
    end
    love.graphics.circle("fill", self.x, self.y, self.radius)

    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", self.x, self.y, self.radius)

    if self:isAttackActive() then
        local ax, ay = self:getAttackCenter()
        love.graphics.setColor(1, 0.85, 0.3, 0.6)
        love.graphics.circle("fill", ax, ay, 22)
    end
end

return Player
