local Enemy = require("src.entities.enemy")
local EnemyFast = require("src.entities.enemy_fast")

local EnemySystem = {}

function EnemySystem.spawn(enemies)
    local w = love.graphics.getWidth()

    -- Spawn aleatório no topo da tela
    local x = love.math.random(50, w - 50)
    local y = -30 -- acima da tela

    local enemy
    if love.math.random() < 0.3 then
        enemy = EnemyFast.new(x, y)
    else
        enemy = Enemy.new(x, y)
    end

    table.insert(enemies, enemy)
end

function EnemySystem.update(enemies, player, platforms, dt)
    for _, enemy in ipairs(enemies) do
        enemy:update(player, platforms, dt)
    end
end

function EnemySystem.draw(enemies)
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end

return EnemySystem
