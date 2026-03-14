-- src/entities/enemy_shooter.lua
local Enemy = require("src.entities.enemy")

local EnemyShooter = {}
EnemyShooter.__index = EnemyShooter
setmetatable(EnemyShooter, {__index = Enemy})

function EnemyShooter.new(x, y)
    local self = Enemy.new(x, y, "shooter")
    setmetatable(self, EnemyShooter)
    
    -- Customizações
    self.speed = 50           -- Mais lento
    self.hp = 3               -- Mais vida
    self.maxHp = 3
    self.radius = 14
    self.xpReward = 8         -- Mais XP (mais difícil)
    self.color = {0.6, 0.3, 0.8}  -- Roxo
    
    -- Específico de atirador
    self.shootRange = 300     -- Distância para parar e atirar
    self.shootCooldown = 2.0  -- Atira a cada 2s
    self.shootTimer = 0
    self.projectiles = {}
    self.projectileSpeed = 200
    
    return self
end

-- Sobrescreve o update
function EnemyShooter:update(player, terrain, dt)
    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)
    
    -- Se está longe, persegue
    if dist > self.shootRange then
        self.vx = (dx / dist) * self.speed
        self.vy = (dy / dist) * self.speed  -- Voa em direção ao player
    else
        -- Se está perto, para e atira
        self.vx = 0
        self.vy = 0
        
        self.shootTimer = self.shootTimer - dt
        if self.shootTimer <= 0 then
            self:shoot(player)
            self.shootTimer = self.shootCooldown
        end
    end
    
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    
    -- Atualiza projéteis
    self:updateProjectiles(dt)
end

function EnemyShooter:shoot(player)
    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)
    
    if dist > 0 then
        table.insert(self.projectiles, {
            x = self.x,
            y = self.y,
            vx = (dx / dist) * self.projectileSpeed,
            vy = (dy / dist) * self.projectileSpeed,
            radius = 5,
            lifetime = 4
        })
    end
end

function EnemyShooter:updateProjectiles(dt)
    for i = #self.projectiles, 1, -1 do
        local p = self.projectiles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.lifetime = p.lifetime - dt
        
        if p.lifetime <= 0 then
            table.remove(self.projectiles, i)
        end
    end
end

function EnemyShooter:draw()
    -- Desenha o corpo (método base)
    Enemy.draw(self)
    
    -- Desenha projéteis
    love.graphics.setColor(0.8, 0.2, 0.2)
    for _, p in ipairs(self.projectiles) do
        love.graphics.circle("fill", p.x, p.y, p.radius)
    end
end

return EnemyShooter