local pause = {
	background_path = "./assets/graphics/backgrounds/pause_background.png",
	background = nil,

	idle_buttons_path = {
		"./assets/graphics/pause/menu_idle.png",
		"./assets/graphics/pause/resume_idle.png",
		"./assets/graphics/menu/options_idle.png",
	},
	idle_buttons = {},

	active_buttons_path = {
		"./assets/graphics/pause/menu_active.png",
		"./assets/graphics/pause/resume_active.png",
		"./assets/graphics/menu/options_active.png",
	},
	active_buttons = {},

	label_path = "./assets/graphics/pause/pause_label.png",
	label = nil,

	active = 1,
}

local state_machine = require("state_machine")

function pause.init()
	pause.background = image.load(pause.background_path)

	pause.idle_buttons = {
		image.load(pause.idle_buttons_path[1]),
		image.load(pause.idle_buttons_path[2]),
		image.load(pause.idle_buttons_path[3]),
	}

	pause.active_buttons = {
		image.load(pause.active_buttons_path[1]),
		image.load(pause.active_buttons_path[2]),
		image.load(pause.active_buttons_path[3]),
	}

	pause.label = image.load(pause.label_path)
end

local function clamp_actives()
	if pause.active > 3 then
		pause.active = 1
	elseif pause.active < 1 then
		pause.active = 3
	end
end

local function handle_input()
	if buttons.released.up then
		pause.active = pause.active - 1
		clamp_actives()
	end

	if buttons.released.down then
		pause.active = pause.active + 1
		clamp_actives()
	end
end

function pause.update()
	handle_input()

	if buttons.released.cross then
		if pause.active == 1 then
			state_machine.change_state("GAME")
		elseif pause.active == 2 then
			state_machine.change_state("MENU")
		else
			state_machine.change_state("IN_GAME_OPTIONS")
		end
	end
end

local function render_resume(x)
	if pause.active == 1 then
		pause.active_buttons[2]:blit(x, 100)
	else
		pause.idle_buttons[2]:blit(x, 100)
	end
end

local function render_menu(x)
	if pause.active == 2 then
		pause.active_buttons[1]:blit(x, 150)
	else
		pause.idle_buttons[1]:blit(x, 150)
	end
end

local function render_options(x)
	if pause.active == 3 then
		pause.active_buttons[3]:blit(x, 200)
	else
		pause.idle_buttons[3]:blit(x, 200)
	end
end

function pause.render()
	local pos_x = 480 / 2 - 48

	pause.background:blit(0, 0)

	pause.label:blit(pos_x, 50)

	render_resume(pos_x)
	render_menu(pos_x)
	render_options(pos_x)
end

return pause
