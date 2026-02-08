local CardChoice = {}

function CardChoice.new(cardSystem, choices)
    local self = {
        cardSystem = cardSystem,
        choices = choices,  -- Array de card IDs
        selectedIndex = 1
    }
    setmetatable(self, {__index = CardChoice})
    return self
end

function CardChoice:handleInput()
    -- Teclas 1, 2, 3 para escolha direta
    if love.keyboard.isDown("1") and self.choices[1] then
        return self.choices[1]
    elseif love.keyboard.isDown("2") and self.choices[2] then
        return self.choices[2]
    elseif love.keyboard.isDown("3") and self.choices[3] then
        return self.choices[3]
    end
    
    -- TODO: Mouse support
    return nil
end

function CardChoice:draw()
    local w, h = love.graphics.getDimensions()
    
    -- Fundo escuro
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, w, h)
    
    -- Título
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("ESCOLHA UM PODER", 0, 100, w, "center")
    
    -- Desenha cada carta
    local cardWidth = 200
    local cardHeight = 280
    local spacing = 20
    local totalWidth = (#self.choices * cardWidth) + ((#self.choices - 1) * spacing)
    local startX = (w - totalWidth) / 2
    
    for i, cardId in ipairs(self.choices) do
        local x = startX + (i - 1) * (cardWidth + spacing)
        local y = 200
        
        self:drawCard(x, y, cardWidth, cardHeight, cardId, i)
    end
end

function CardChoice:drawCard(x, y, w, h, cardId, index)
    local definition = self.cardSystem:getDefinition(cardId)
    local currentLevel = self.cardSystem:getCardLevel(cardId)
    local nextLevel = currentLevel + 1
    
    -- Fundo da carta
    love.graphics.setColor(0.2, 0.2, 0.25)
    love.graphics.rectangle("fill", x, y, w, h, 8)
    
    -- Borda
    love.graphics.setColor(0.6, 0.6, 0.7)
    love.graphics.rectangle("line", x, y, w, h, 8)
    
    -- Nome
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(definition.name, x + 10, y + 20, w - 20, "center")
    
    -- Nível
    local levelText = string.format("Nível %d → %d", currentLevel, nextLevel)
    if currentLevel == 0 then
        levelText = "NOVO!"
    end
    love.graphics.printf(levelText, x + 10, y + 50, w - 20, "center")
    
    -- Descrição
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf(definition.description, x + 10, y + 90, w - 20, "left")
    
    -- Tecla
    love.graphics.setColor(1, 1, 0)
    love.graphics.printf(string.format("[%d]", index), x + 10, y + h - 30, w - 20, "center")
end

return CardChoice