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
    local entityBottom = entity.y + entity.height / 2
    
    if entityBottom >= groundHeight then
        entity.y = groundHeight - entity.height / 2
        entity.vy = 0
        entity.grounded = true
        return true
    end
    
    entity.grounded = false
    return false
end

return Physics