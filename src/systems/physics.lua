local Physics = {}

Physics.GRAVITY = 800
Physics.TERMINAL_VELOCITY = 600

function Physics.applyGravity(entity, dt)
    entity.vy = entity.vy + Physics.GRAVITY * dt
    if entity.vy > Physics.TERMINAL_VELOCITY then
        entity.vy = Physics.TERMINAL_VELOCITY
    end
end

-- Resolve colisão com o terreno
function Physics.resolveTerrainCollision(entity, terrain)
    local Terrain = require("src.systems.terrain")
    local groundHeight = Terrain.getHeightAt(terrain, entity.x)
    
    -- Usa radius para inimigos, height para player
    local size = entity.height and (entity.height / 2) or entity.radius
    local entityBottom = entity.y + size
    
    if entityBottom >= groundHeight then
        entity.y = groundHeight - size
        entity.vy = 0
        entity.grounded = true
        return true
    end
    
    entity.grounded = false
    return false
end

return Physics