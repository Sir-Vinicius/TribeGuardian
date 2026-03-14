-- src/entities/enemy.lua (CLASSE BASE)
local Enemy = {}
Enemy.__index = Enemy

-- Construtor base com valores padrão
function Enemy.new(x, y, type)
    local self = setmetatable({
        x = x,
        y = y,
        type = type or "basic",
        
        -- Atributos padrão (todos os inimigos TÊM que ter)
        radius = 12,
        speed = 80,
        hp = 2,
        maxHp = 2,
        damage = 1,
        xpReward = 5,  -- ← XP que dá ao morrer
        color = {0.9, 0.35, 0.35},
        
        -- Física (platformer)
        vx = 0,
        vy = 0,
        grounded = false,
        
        -- Comportamento
        state = "chase",  -- "chase", "shoot", "idle"
        attackCooldown = 0,
        projectiles = {}
    }, Enemy)
    
    return self
end

-- Método base de update (pode ser sobrescrito)
function Enemy:update(player, terrain, dt)
    -- Comportamento padrão: perseguir player
    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)
    
    if dist > 0 then
        self.vx = (dx / dist) * self.speed
        self.vy = (dy / dist) * self.speed  -- Inimigos voam em direção ao player
    end
    
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

-- Método base de dano
function Enemy:takeDamage(amount)
    self.hp = self.hp - amount
    return self.hp <= 0, self.xpReward  -- Retorna (morreu?, xp)
end

-- Método base de desenho
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