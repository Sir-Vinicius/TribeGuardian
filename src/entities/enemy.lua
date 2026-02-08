local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, type)
    local self = setmetatable({
        x = x,
        y = y,
        type = type or "basic",
        radius = 12,
        speed = 80,
        hp = 2,
        maxHp = 2,
        damage = 1,
        color = {0.9, 0.35, 0.35}
    }, Enemy)
    
    return self
end

function Enemy:update(player, dt)
    -- IA simples: voa direto pro player
    local dx, dy = player.x - self.x, player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)
    
    if dist > 0 then
        self.x = self.x + (dx / dist) * self.speed * dt
        self.y = self.y + (dy / dist) * self.speed * dt
    end
end

function Enemy:takeDamage(amount)
    self.hp = self.hp - amount
    return self.hp <= 0
end

function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", self.x, self.y, self.radius)
    
    -- Barra de HP
    if self.hp < self.maxHp then
        local barWidth = self.radius * 2
        local hpPercent = self.hp / self.maxHp
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", self.x - barWidth/2, self.y - self.radius - 8, barWidth, 3)
        love.graphics.setColor(0.3, 0.9, 0.3)
        love.graphics.rectangle("fill", self.x - barWidth/2, self.y - self.radius - 8, barWidth * hpPercent, 3)
    end
end

return Enemy