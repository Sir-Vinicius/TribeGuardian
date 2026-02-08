local Terrain = {}

function Terrain.create()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    -- Pontos do terreno (x, y)
    local points = {
        {x = 0, y = h - 100},
        {x = 150, y = h - 100},
        {x = 250, y = h - 60},   -- subida
        {x = 350, y = h - 60},
        {x = 450, y = h - 120},  -- descida (vale)
        {x = 550, y = h - 120},
        {x = 650, y = h - 80},   -- subida
        {x = 750, y = h - 80},
        {x = w, y = h - 80}
    }
    
    return {
        points = points,
        groundY = h  -- usado pra desenhar o preenchimento
    }
end

-- Interpola altura do terreno em qualquer posição X
function Terrain.getHeightAt(terrain, x)
    local points = terrain.points
    
    -- Acha os dois pontos mais próximos
    for i = 1, #points - 1 do
        local p1, p2 = points[i], points[i + 1]
        
        if x >= p1.x and x <= p2.x then
            -- Interpolação linear
            local t = (x - p1.x) / (p2.x - p1.x)
            return p1.y + (p2.y - p1.y) * t
        end
    end
    
    -- Se estiver fora, retorna primeira ou última altura
    if x < points[1].x then
        return points[1].y
    else
        return points[#points].y
    end
end

function Terrain.draw(terrain)
    local points = terrain.points
    
    -- Desenha o preenchimento (polígono até o fundo da tela)
    local vertices = {}
    for _, p in ipairs(points) do
        table.insert(vertices, p.x)
        table.insert(vertices, p.y)
    end
    -- Fecha o polígono pelo fundo
    local w, h = love.graphics.getDimensions()
    table.insert(vertices, points[#points].x)
    table.insert(vertices, h)
    table.insert(vertices, points[1].x)
    table.insert(vertices, h)
    
    love.graphics.setColor(0.25, 0.2, 0.15)
    love.graphics.polygon("fill", vertices)
    
    -- Desenha a linha do topo
    love.graphics.setColor(0.15, 0.12, 0.1)
    love.graphics.setLineWidth(3)
    for i = 1, #points - 1 do
        love.graphics.line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
    end
    love.graphics.setLineWidth(1)
end

return Terrain