local Player = require("src.entities.player")
local EnemySystem = require("src.systems.enemy_system")
local CombatSystem = require("src.systems.combat_system")

local game = {
    player = nil,
    enemies = {},
    spawnTimer = 0,
    spawnInterval = 1.5,
    score = 0,
    running = true
}

local function resetGame()
    local w, h = love.graphics.getDimensions()
    game.player = Player.new(w / 2, h / 2)
    game.enemies = {}
    game.spawnTimer = 0
    game.score = 0
    game.running = true
end

function love.load()
    love.graphics.setBackgroundColor(0.07, 0.07, 0.09)
    love.graphics.setDefaultFilter("nearest", "nearest")
    resetGame()
end

function love.update(dt)
    if not game.running then
        if love.keyboard.isDown("r") then
            resetGame()
        end
        return
    end

    game.player:update(dt)

    game.spawnTimer = game.spawnTimer + dt
    if game.spawnTimer >= game.spawnInterval then
        game.spawnTimer = 0
        EnemySystem.spawn(game.enemies, game.player)
    end

    EnemySystem.update(game.enemies, game.player, dt)

    local killed = CombatSystem.resolveAttack(game.player, game.enemies)
    game.score = game.score + killed

    local playerAlive = CombatSystem.resolveContactDamage(game.player, game.enemies, dt)
    if not playerAlive then
        game.running = false
    end
end

function love.draw()
    game.player:draw()
    EnemySystem.draw(game.enemies)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("HP: %d", game.player.hp), 12, 10)
    love.graphics.print(string.format("Abates: %d", game.score), 12, 30)
    love.graphics.print("WASD/Setas para mover | ESPAÇO para atacar", 12, 50)

    if not game.running then
        love.graphics.printf("Você foi derrotado! Pressione R para reiniciar", 0, 250, 960, "center")
    end
end
