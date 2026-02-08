local XPSystem = {}

-- Tabela de XP necessário por nível
-- Progressão exponencial suave
local XP_THRESHOLDS = {
    10,   -- Nível 2
    25,   -- Nível 3
    45,   -- Nível 4
    70,   -- Nível 5
    100,  -- Nível 6
    135,  -- etc...
    175,
    220,
    270,
    325,
}

function XPSystem.new()
    local self = {
        currentXP = 0,
        level = 1,
        totalXP = 0
    }
    setmetatable(self, {__index = XPSystem})
    return self
end

function XPSystem.addXP(self, amount)
    self.currentXP = self.currentXP + amount
    self.totalXP = self.totalXP + amount
    
    -- Checa se upou
    if self:checkLevelUp() then
        return true  -- Retorna true se upou
    end
    return false
end

function XPSystem.checkLevelUp(self)
    local threshold = XP_THRESHOLDS[self.level]
    if threshold and self.currentXP >= threshold then
        self.level = self.level + 1
        self.currentXP = self.currentXP - threshold
        return true
    end
    return false
end

function XPSystem.getProgressPercent(self)
    local threshold = XP_THRESHOLDS[self.level]
    if not threshold then return 1 end  -- Max level
    return self.currentXP / threshold
end

return XPSystem