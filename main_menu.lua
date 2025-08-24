local state_machine = require("state_machine")

local main_menu = {
	background = "./assets/graphics/backgrounds/menu_background.png",
	idle_paths = {
		"./assets/graphics/menu/start_idle.png",
		"./assets/graphics/menu/continue_idle.png",
		"./assets/graphics/menu/options_idle.png",
	},
	active_paths = {
		"./assets/graphics/menu/start_active.png",
		"./assets/graphics/menu/continue_active.png",
		"./assets/graphics/menu/options_active.png",
	},
}

function main_menu.update()
	if buttons.released.down then
		active = active + 1
		clamp_actives()
	end
	if buttons.released.up then
		active = active - 1
		clamp_actives()
	end

	if buttons.released.cross and (active == 1 or active == 2) then
		state_machine.change_state("GAME")
	end
end

return main_menu
