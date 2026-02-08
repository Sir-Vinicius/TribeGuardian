local GameState = {}

local STATES = {
    MENU = "menu",
    PLAYING = "playing",
    CARD_CHOICE = "card_choice",
    PAUSED = "paused",
    GAME_OVER = "game_over"
}

function GameState.new(initialState)
    local self = {
        current = initialState or STATES.MENU,
        previous = nil,
        STATES = STATES
    }
    setmetatable(self, {__index = GameState})
    return self
end

function GameState:setState(newState)
    self.previous = self.current
    self.current = newState
end

function GameState:is(state)
    return self.current == state
end

return GameState