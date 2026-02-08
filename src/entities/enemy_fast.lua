local Enemy = require("src.entities.enemy")

local FastEnemy = setmetatable({}, {__index = Enemy})
FastEnemy.__index = FastEnemy

function FastEnemy.new(x, y)
    local self = Enemy.new(x, y, "fast")
    setmetatable(self, FastEnemy)
    
    -- Customizações
    self.speed = 140  -- mais rápido
    self.hp = 1       -- menos vida
    self.radius = 10  -- menor
    self.color = {0.9, 0.6, 0.2}  -- laranja
    
    return self
end

-- Pode sobrescrever métodos se necessário
-- function FastEnemy:update(player, dt)
--     -- comportamento especial
-- end

return FastEnemy