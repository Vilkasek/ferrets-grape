local state_machine = require("state_machine")

local game_over = {
	background_path = "./assets/graphics/backgrounds/game_over.png",
	background = nil,

	label_path = "./assets/graphics/pause/back_to_menu.png",
	label = nil,
}

function game_over.init()
	game_over.background = image.load(game_over.background_path)
	game_over.label = image.load(game_over.label_path)
end

function game_over.update()
	if buttons.released.cross then
		state_machine.change_state("MENU")
	end
end

function game_over.render()
	game_over.background:blit(0, 0)
  game_over.label:blit(240-80, 130)
end

return game_over
