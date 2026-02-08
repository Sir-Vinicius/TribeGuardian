local Physics = require("src.systems.physics")

local Player = {}
Player.__index = Player

function Player.new(x, y)
    return setmetatable({
        x = x,
        y = y,
        width = 24,
        height = 32,
        
        -- Física
        vx = 0,
        vy = 0,
        speed = 200,
        jumpForce = -380,
        grounded = false,
        
        -- Combate
        hp = 5,
        shootCooldown = 0.2,
        shootTimer = 0,
        bullets = {},
        bulletSpeed = 500,
        bulletDamage = 1,
        
        -- Estado
        facingRight = true,
        hitCooldown = 0.6,
        hitTimer = 0
    }, Player)
end

function Player:update(dt, terrain)
    -- Movimento horizontal
    local dx = 0
    if love.keyboard.isDown("a", "left") then
        dx = -1
        self.facingRight = false
    end
    if love.keyboard.isDown("d", "right") then
        dx = 1
        self.facingRight = true
    end
    
    self.vx = dx * self.speed
    self.x = self.x + self.vx * dt
    
    -- Limites laterais
    local w = love.graphics.getWidth()
    self.x = math.max(self.width/2, math.min(w - self.width/2, self.x))
    
    -- Pulo
    if (love.keyboard.isDown("w", "up", "space")) and self.grounded then
        self.vy = self.jumpForce
        self.grounded = false
    end
    
    -- Física
    Physics.applyGravity(self, dt)
    self.y = self.y + self.vy * dt
    
    -- Colisão com terreno
    Physics.resolveTerrainCollision(self, terrain)
    
    -- Direção do tiro (mouse)
    local mx, my = love.mouse.getPosition()
    local shootDirX = mx - self.x
    local shootDirY = my - self.y
    local len = math.sqrt(shootDirX * shootDirX + shootDirY * shootDirY)
    if len > 0 then
        shootDirX, shootDirY = shootDirX / len, shootDirY / len
    end
    
    -- Tiro automático
    self.shootTimer = self.shootTimer - dt
    if self.shootTimer <= 0 then
        self:shoot(shootDirX, shootDirY)
        self.shootTimer = self.shootCooldown
    end
    
    -- Atualizar balas
    local screenW, screenH = love.graphics.getDimensions()
    for i = #self.bullets, 1, -1 do
        local b = self.bullets[i]
        b.x = b.x + b.vx * dt
        b.y = b.y + b.vy * dt
        b.lifetime = b.lifetime - dt
        
        if b.lifetime <= 0 or b.x < 0 or b.x > screenW or b.y < 0 or b.y > screenH then
            table.remove(self.bullets, i)
        end
    end
    
    self.hitTimer = math.max(0, self.hitTimer - dt)
end

function Player:shoot(dirX, dirY)
    local gunOffsetX = self.facingRight and 12 or -12
    local gunOffsetY = -4
    
    table.insert(self.bullets, {
        x = self.x + gunOffsetX,
        y = self.y + gunOffsetY,
        vx = dirX * self.bulletSpeed,
        vy = dirY * self.bulletSpeed,
        radius = 4,
        damage = self.bulletDamage,
        lifetime = 4
    })
end

function Player:takeDamage(amount)
    if self.hitTimer > 0 then return true end
    
    self.hp = self.hp - amount
    self.hitTimer = self.hitCooldown
    return self.hp > 0
end

function Player:draw()
    if self.hitTimer > 0 then
        love.graphics.setColor(1, 0.5, 0.5)
    else
        love.graphics.setColor(0.4, 0.75, 1)
    end
    
    local x = self.x - self.width/2
    local y = self.y - self.height/2
    love.graphics.rectangle("fill", x, y, self.width, self.height)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x, y, self.width, self.height)
    
    -- Indicador de mira
    love.graphics.setColor(1, 1, 1, 0.8)
    local mx, my = love.mouse.getPosition()
    local dirX, dirY = mx - self.x, my - self.y
    local len = math.sqrt(dirX * dirX + dirY * dirY)
    if len > 0 then
        dirX, dirY = dirX / len, dirY / len
        love.graphics.line(
            self.x, self.y - 4,
            self.x + dirX * 18,
            self.y - 4 + dirY * 18
        )
    end
    
    -- Balas
    love.graphics.setColor(1, 0.9, 0.3)
    for _, b in ipairs(self.bullets) do
        love.graphics.circle("fill", b.x, b.y, b.radius)
    end
end

return Player