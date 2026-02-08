local CombatSystem = {}

local function distanceSq(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return dx * dx + dy * dy
end

function CombatSystem.resolveBullets(player, enemies)
    local killed = 0
    
    for i = #player.bullets, 1, -1 do
        local bullet = player.bullets[i]
        local hitSomething = false
        
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            local reach = bullet.radius + enemy.radius
            
            if distanceSq(bullet.x, bullet.y, enemy.x, enemy.y) <= reach * reach then
                if enemy:takeDamage(bullet.damage) then
                    table.remove(enemies, j)
                    killed = killed + 1
                end
                hitSomething = true
                break
            end
        end
        
        if hitSomething then
            table.remove(player.bullets, i)
        end
    end
    
    return killed
end

-- Colisão círculo (inimigo) com retângulo (player)
function CombatSystem.resolveContactDamage(player, enemies)
    local px = player.x - player.width/2
    local py = player.y - player.height/2
    
    for _, enemy in ipairs(enemies) do
        -- Acha ponto mais próximo do retângulo
        local closestX = math.max(px, math.min(enemy.x, px + player.width))
        local closestY = math.max(py, math.min(enemy.y, py + player.height))
        
        if distanceSq(enemy.x, enemy.y, closestX, closestY) <= enemy.radius * enemy.radius then
            return player:takeDamage(enemy.damage)
        end
    end
    
    return true
end

return CombatSystem