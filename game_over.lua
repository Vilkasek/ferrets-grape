local state_machine = require("state_machine")

local game_over = {
  background_path = "./assets/graphics/backgrounds/game_over.png",
  background = nil,
}

function game_over.init()
  game_over.background = image.load(game_over.background_path)
end

function game_over.update()
  if buttons.released.cross then
    state_machine.change_state("MENU")
  end
end

function game_over.render()
  game_over.background:blit(0, 0)
end

return game_over
