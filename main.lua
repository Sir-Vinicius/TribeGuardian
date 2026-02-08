local Player = require("src.entities.player")
local EnemySystem = require("src.systems.enemy_system")
local CombatSystem = require("src.systems.combat_system")
local XPSystem = require("src.systems.xp_system")
local CardSystem = require("src.systems.card_system")
local GameState = require("src.systems.game_state")
local CardChoice = require("src.ui.card_choice")
local Terrain = require("src.systems.terrain")

local game = {
    state = nil,
    player = nil,
    enemies = {},
    terrain = nil,
    xpSystem = nil,
    cardSystem = nil,
    cardChoice = nil,
    spawnTimer = 0,
    spawnInterval = 1.5,
    score = 0
}

local function resetGame()
    local w, h = love.graphics.getDimensions()
    game.state = GameState.new(game.state.STATES.PLAYING)
    game.terrain = Terrain.create()
    game.player = Player.new(w / 2, h / 2)
    game.enemies = {}
    game.xpSystem = XPSystem.new()
    game.cardSystem = CardSystem.new()
    game.cardChoice = nil
    game.spawnTimer = 0
    game.score = 0
end

function love.load()
    love.graphics.setBackgroundColor(0.07, 0.07, 0.09)
    love.graphics.setDefaultFilter("nearest", "nearest")
    game.state = GameState.new()
    resetGame()
end

function love.update(dt)
    -- Se morreu
    if game.state:is(game.state.STATES.GAME_OVER) then
        if love.keyboard.isDown("r") then
            resetGame()
        end
        return
    end
    
    -- Se está escolhendo carta
    if game.state:is(game.state.STATES.CARD_CHOICE) then
        local chosenCardId = game.cardChoice:handleInput()
        if chosenCardId then
            game.cardSystem:addCard(chosenCardId)
            game.state:setState(game.state.STATES.PLAYING)
            game.cardChoice = nil
        end
        return
    end
    
    -- Gameplay normal
    game.player:update(dt, game.terrain)
    
    game.spawnTimer = game.spawnTimer + dt
    if game.spawnTimer >= game.spawnInterval then
        game.spawnTimer = 0
        EnemySystem.spawn(game.enemies, game.player)
    end
    
    EnemySystem.update(game.enemies, game.player, dt)
    
    local killed = CombatSystem.resolveBullets(game.player, game.enemies)
    game.score = game.score + killed
    
    -- ← NOVO: Dá XP ao matar
    if killed > 0 then
        -- Assume 5 XP por inimigo (você pode pegar do inimigo.xpReward)
        local leveledUp = game.xpSystem:addXP(killed * 5)
        
        if leveledUp then
            -- Pausa o jogo e mostra cartas
            game.state:setState(game.state.STATES.CARD_CHOICE)
            local choices = game.cardSystem:getRandomChoices(3)
            game.cardChoice = CardChoice.new(game.cardSystem, choices)
        end
    end
    
    local playerAlive = CombatSystem.resolveContactDamage(game.player, game.enemies, dt)
    if not playerAlive then
        game.state:setState(game.state.STATES.GAME_OVER)
    end
end

function love.draw()
    -- Desenha o terreno
    Terrain.draw(game.terrain)
    
    -- Desenha o jogo
    game.player:draw()
    EnemySystem.draw(game.enemies)
    
    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("HP: %d", game.player.hp), 12, 10)
    love.graphics.print(string.format("Abates: %d", game.score), 12, 30)
    love.graphics.print(string.format("Level: %d", game.xpSystem.level), 12, 50)
    
    -- Barra de XP
    local barWidth = 200
    local barHeight = 10
    local barX, barY = 12, 70
    
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)
    
    love.graphics.setColor(0.2, 0.8, 0.3)
    local progress = game.xpSystem:getProgressPercent()
    love.graphics.rectangle("fill", barX, barY, barWidth * progress, barHeight)
    
    -- Tela de escolha de carta
    if game.state:is(game.state.STATES.CARD_CHOICE) and game.cardChoice then
        game.cardChoice:draw()
    end
    
    -- Game Over
    if game.state:is(game.state.STATES.GAME_OVER) then
        love.graphics.printf("Você foi derrotado! Pressione R para reiniciar", 0, 250, 960, "center")
    end
end