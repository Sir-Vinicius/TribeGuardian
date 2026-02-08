local Player = require("src.entities.player")
local EnemySystem = require("src.systems.enemy_system")
local CombatSystem = require("src.systems.combat_system")
local Terrain = require("src.systems.terrain")

local game = {
    player = nil,
    enemies = {},
    terrain = nil,
    spawnTimer = 0,
    spawnInterval = 1.8,
    score = 0,
    running = true
}

local function resetGame()
    local w, h = love.graphics.getDimensions()
    game.terrain = Terrain.create()
    
    -- Spawna o player no meio, em cima do terreno
    local spawnX = w / 2
    local groundY = Terrain.getHeightAt(game.terrain, spawnX)
    game.player = Player.new(spawnX, groundY - 100)
    
    game.enemies = {}
    game.spawnTimer = 0
    game.score = 0
    game.running = true
end

function love.load()
    love.graphics.setBackgroundColor(0.12, 0.14, 0.18)
    love.graphics.setDefaultFilter("nearest", "nearest")
    resetGame()
end

function love.update(dt)
    if not game.running then
        if love.keyboard.isDown("r") then resetGame() end
        return
    end
    
    game.player:update(dt, game.terrain)
    
    -- Spawn de inimigos
    game.spawnTimer = game.spawnTimer + dt
    if game.spawnTimer >= game.spawnInterval then
        game.spawnTimer = 0
        EnemySystem.spawn(game.enemies)
    end
    
    EnemySystem.update(game.enemies, game.player, dt)
    
    -- Combate
    local killed = CombatSystem.resolveBullets(game.player, game.enemies)
    game.score = game.score + killed
    
    local playerAlive = CombatSystem.resolveContactDamage(game.player, game.enemies)
    if not playerAlive then
        game.running = false
    end
end

function love.draw()
    -- Céu
    love.graphics.clear(0.45, 0.6, 0.75)
    
    -- Terreno
    Terrain.draw(game.terrain)
    
    -- Entidades
    game.player:draw()
    EnemySystem.draw(game.enemies)
    
    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("HP: %d", game.player.hp), 12, 10)
    love.graphics.print(string.format("Abates: %d", game.score), 12, 30)
    love.graphics.print("A/D: mover | W/Espaço: pular | Mouse: mirar", 12, 50)
    
    if not game.running then
        love.graphics.printf("Você foi derrotado! Pressione R para reiniciar", 
                            0, 250, 960, "center")
    end
end
