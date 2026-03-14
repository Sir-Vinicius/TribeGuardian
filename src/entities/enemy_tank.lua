-- src/entities/enemy_tank.lua
local Enemy = require("src.entities.enemy")

local EnemyTank = {}
EnemyTank.__index = EnemyTank
setmetatable(EnemyTank, {__index = Enemy})

function EnemyTank.new(x, y)
    local self = Enemy.new(x, y, "tank")
    setmetatable(self, EnemyTank)
    
    self.speed = 40           -- Muito lento
    self.hp = 8               -- Muita vida
    self.maxHp = 8
    self.radius = 18          -- Grande
    self.damage = 2           -- Dano maior
    self.xpReward = 15        -- Muito XP
    self.color = {0.4, 0.4, 0.5}  -- Cinza
    
    return self
end

-- Usa update padrão (só persegue)

return EnemyTank