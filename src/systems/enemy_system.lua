-- src/systems/enemy_system.lua
local Enemy = require("src.entities.enemy")
local EnemyFast = require("src.entities.enemy_fast")
local EnemyShooter = require("src.entities.enemy_shooter")
local EnemyTank = require("src.entities.enemy_tank")

local EnemySystem = {}

function EnemySystem.spawn(enemies, player)
    local w = love.graphics.getWidth()
    
    -- Spawn aleatório no topo
    local x = love.math.random(50, w - 50)
    local y = -30
    
    -- Escolhe tipo baseado em probabilidade
    local rand = love.math.random()
    local enemy
    
    if rand < 0.5 then
        enemy = Enemy.new(x, y)        -- 50% básico
    elseif rand < 0.75 then
        enemy = EnemyFast.new(x, y)    -- 25% rápido
    elseif rand < 0.9 then
        enemy = EnemyShooter.new(x, y) -- 15% atirador
    else
        enemy = EnemyTank.new(x, y)    -- 10% tanque
    end
    
    table.insert(enemies, enemy)
end

function EnemySystem.update(enemies, player, terrain, dt)
    for _, enemy in ipairs(enemies) do
        enemy:update(player, terrain, dt)
    end
end

function EnemySystem.draw(enemies)
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
end

return EnemySystem