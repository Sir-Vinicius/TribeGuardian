local CardSystem = {}

-- Definições das cartas
local CARD_DEFINITIONS = {
    -- ATAQUES ATIVOS
    {
        id = "orbital_projectile",
        name = "Projétil Orbital",
        description = "Orbes giram ao redor do jogador",
        type = "attack",
        maxLevel = 9,
        rarity = "common",
        
        -- O que cada level faz
        effects = {
            {level = 1, orbCount = 1, damage = 5, speed = 60},
            {level = 2, orbCount = 1, damage = 7, speed = 60},
            {level = 3, orbCount = 2, damage = 7, speed = 60},
            {level = 4, orbCount = 2, damage = 10, speed = 80},
            {level = 5, orbCount = 3, damage = 10, speed = 80},
            -- ... até level 9
        }
    },
    
    {
        id = "guided_arrow",
        name = "Flecha Guiada",
        description = "Ataque automático no inimigo mais próximo",
        type = "attack",
        maxLevel = 9,
        rarity = "common",
        
        effects = {
            {level = 1, projectileCount = 1, damage = 8, cooldown = 1.0},
            {level = 2, projectileCount = 1, damage = 12, cooldown = 0.9},
            {level = 3, projectileCount = 2, damage = 12, cooldown = 0.9},
            -- ...
        }
    },
    
    -- PASSIVAS
    {
        id = "brute_force",
        name = "Força Bruta",
        description = "Aumenta o dano global",
        type = "passive",
        maxLevel = 5,
        rarity = "common",
        
        effects = {
            {level = 1, damageMultiplier = 1.10},  -- +10%
            {level = 2, damageMultiplier = 1.20},  -- +20%
            {level = 3, damageMultiplier = 1.35},  -- +35%
            {level = 4, damageMultiplier = 1.50},  -- +50%
            {level = 5, damageMultiplier = 1.75},  -- +75%
        }
    },
    
    -- Adicione mais...
}

function CardSystem.new()
    local self = {
        activeCards = {},  -- Cartas que o player pegou {id, level}
        availablePool = {}  -- Pool de cartas disponíveis na run
    }
    setmetatable(self, {__index = CardSystem})
    return self
end

function CardSystem:hasCard(cardId)
    return self.activeCards[cardId] ~= nil
end

function CardSystem:getCardLevel(cardId)
    local card = self.activeCards[cardId]
    return card and card.level or 0
end

function CardSystem:canUpgradeCard(cardId)
    local definition = self:getDefinition(cardId)
    if not definition then return false end
    
    local currentLevel = self:getCardLevel(cardId)
    return currentLevel < definition.maxLevel
end

function CardSystem:addCard(cardId)
    if self:hasCard(cardId) then
        -- Já tem, então upa
        self.activeCards[cardId].level = self.activeCards[cardId].level + 1
    else
        -- Carta nova
        self.activeCards[cardId] = {
            id = cardId,
            level = 1
        }
    end
end

function CardSystem:getDefinition(cardId)
    for _, def in ipairs(CARD_DEFINITIONS) do
        if def.id == cardId then
            return def
        end
    end
end

function CardSystem:getRandomChoices(count)
    -- Retorna 'count' cartas aleatórias
    -- Filtra cartas que já estão no max level
    local available = {}
    
    for _, def in ipairs(CARD_DEFINITIONS) do
        if self:canUpgradeCard(def.id) then
            table.insert(available, def.id)
        end
    end
    
    -- Embaralha e pega as primeiras 'count'
    local choices = {}
    for i = 1, math.min(count, #available) do
        local randomIndex = love.math.random(1, #available)
        table.insert(choices, available[randomIndex])
        table.remove(available, randomIndex)
    end
    
    return choices
end

-- Retorna os efeitos atuais de uma carta baseado no level
function CardSystem:getActiveEffects(cardId)
    local card = self.activeCards[cardId]
    if not card then return nil end
    
    local definition = self:getDefinition(cardId)
    return definition.effects[card.level]
end

return CardSystem