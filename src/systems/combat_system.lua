local CombatSystem = {}

local function distanceSq(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return dx * dx + dy * dy
end

function CombatSystem.resolveAttack(player, enemies)
    if not player:isAttackActive() then
        return 0
    end

    local killed = 0
    local ax, ay = player:getAttackCenter()
    local attackRadius = 22

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        local reach = attackRadius + enemy.radius
        if distanceSq(ax, ay, enemy.x, enemy.y) <= reach * reach then
            enemy.hp = enemy.hp - player.attackDamage
            if enemy.hp <= 0 then
                table.remove(enemies, i)
                killed = killed + 1
            end
        end
    end

    return killed
end

function CombatSystem.resolveContactDamage(player, enemies, dt)
    local _ = dt

    for _, enemy in ipairs(enemies) do
        local reach = player.radius + enemy.radius
        if distanceSq(player.x, player.y, enemy.x, enemy.y) <= reach * reach then
            return player:takeDamage(1)
        end
    end

    return true
end

return CombatSystem
