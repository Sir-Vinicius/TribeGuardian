-- src/entities/enemy_fast.lua
local Enemy = require("src.entities.enemy")

local EnemyFast = {}
EnemyFast.__index = EnemyFast
setmetatable(EnemyFast, {__index = Enemy})

function EnemyFast.new(x, y)
    local self = Enemy.new(x, y, "fast")
    setmetatable(self, EnemyFast)
    
    -- Customizações
    self.speed = 140      -- Mais rápido
    self.hp = 1           -- Menos vida
    self.maxHp = 1
    self.radius = 10      -- Menor
    self.xpReward = 3     -- Menos XP (mais fácil)
    self.color = {0.9, 0.6, 0.2}  -- Laranja
    
    return self
end

-- Usa o update padrão de Enemy (só persegue)

return EnemyFast