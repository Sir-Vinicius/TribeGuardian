local EnemySystem = {}

local function distance(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return math.sqrt(dx * dx + dy * dy), dx, dy
end

function EnemySystem.spawn(enemies, player)
    local w, h = love.graphics.getDimensions()
    local side = love.math.random(1, 4)
    local x, y

    if side == 1 then
        x, y = 0, love.math.random(0, h)
    elseif side == 2 then
        x, y = w, love.math.random(0, h)
    elseif side == 3 then
        x, y = love.math.random(0, w), 0
    else
        x, y = love.math.random(0, w), h
    end

    local dist = distance(x, y, player.x, player.y)
    if dist < 120 then
        return
    end

    enemies[#enemies + 1] = {
        x = x,
        y = y,
        radius = 12,
        speed = love.math.random(70, 110),
        hp = 2
    }
end

function EnemySystem.update(enemies, player, dt)
    for _, enemy in ipairs(enemies) do
        local dist, dx, dy = distance(enemy.x, enemy.y, player.x, player.y)
        if dist > 0 then
            enemy.x = enemy.x + (dx / dist) * enemy.speed * dt
            enemy.y = enemy.y + (dy / dist) * enemy.speed * dt
        end
    end
end

function EnemySystem.draw(enemies)
    for _, enemy in ipairs(enemies) do
        love.graphics.setColor(0.95, 0.35, 0.35)
        love.graphics.circle("fill", enemy.x, enemy.y, enemy.radius)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", enemy.x, enemy.y, enemy.radius)
    end
end

return EnemySystem
