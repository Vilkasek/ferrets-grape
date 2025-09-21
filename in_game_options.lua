local state_machine = require("state_machine")

local in_game_options = {
	volume_big_path = "./assets/graphics/options/volume_big.png",
	volume_small_path = "./assets/graphics/options/volume_small.png",

	background_path = "./assets/graphics/backgrounds/pause_background.png",

	arrows_idle_paths = {
		"./assets/graphics/options/arrow_left_idle.png",
		"./assets/graphics/options/arrow_right_idle.png",
	},

	arrows_active_paths = {
		"./assets/graphics/options/arrow_left_active.png",
		"./assets/graphics/options/arrow_right_active.png",
	},

	labels_paths = {
		"./assets/graphics/options/music_label.png",
		"./assets/graphics/options/effects_label.png",
		"./assets/graphics/options/menu_label.png",
		"./assets/graphics/options/back_to_menu.png",
	},

	arrows_idle = nil,
	arrows_active = nil,

	volume_big = nil,
	volume_small = nil,

	labels = nil,

	background = nil,

	music_level = 5,
	effects_level = 10,
	menu_level = 10,

	footstep = nil,
	jumpsound = nil,
	music = nil,
	menusound = nil,

	activable = { "MUSIC", "SOUNDS", "MENU" },
	active = 1,
}

function in_game_options.init(foot, jump, m, mn)
	in_game_options.background = image.load(in_game_options.background_path)

	in_game_options.volume_big = image.load(in_game_options.volume_big_path)
	in_game_options.volume_small = image.load(in_game_options.volume_small_path)
	in_game_options.background = image.load(in_game_options.background_path)

	in_game_options.footstep = foot
	in_game_options.jumpsound = jump
	in_game_options.music = m
	in_game_options.menusound = mn

	in_game_options.arrows_idle = { image.load(in_game_options.arrows_idle_paths[1]), image.load(in_game_options.arrows_idle_paths[2]) }
	in_game_options.arrows_active = { image.load(in_game_options.arrows_active_paths[1]), image.load(in_game_options.arrows_active_paths[2]) }

	in_game_options.labels = {
		image.load(in_game_options.labels_paths[1]),
		image.load(in_game_options.labels_paths[2]),
		image.load(in_game_options.labels_paths[3]),
		image.load(in_game_options.labels_paths[4]),
	}
end

local function clamp_actives()
	if in_game_options.active > #in_game_options.activable then
		in_game_options.active = 1
	elseif in_game_options.active < 1 then
		in_game_options.active = #in_game_options.activable
	end
end

local function clamp_level()
	if in_game_options.music_level <= 0 then
		in_game_options.music_level = 0
	elseif in_game_options.music_level >= 10 then
		in_game_options.music_level = 10
	end

	if in_game_options.effects_level <= 0 then
		in_game_options.effects_level = 0
	elseif in_game_options.effects_level >= 10 then
		in_game_options.effects_level = 10
	end

	if in_game_options.menu_level <= 0 then
		in_game_options.menu_level = 0
	elseif in_game_options.menu_level >= 10 then
		in_game_options.menu_level = 10
	end
end

local function change_volume(bar)
	if buttons.released.left then
		if bar == 1 then
			in_game_options.music_level = in_game_options.music_level - 1
			in_game_options.music:vol(in_game_options.music_level * 10)
			clamp_level()
		elseif bar == 2 then
			in_game_options.effects_level = in_game_options.effects_level - 1
			in_game_options.footstep:vol(in_game_options.effects_level * 10)
			in_game_options.jumpsound:vol(in_game_options.effects_level * 10)
			clamp_level()
		elseif bar == 3 then
			in_game_options.menu_level = in_game_options.menu_level - 1
			in_game_options.menusound:vol(in_game_options.menu_level * 10)
			clamp_level()
		end
	end

	if buttons.released.right then
		if bar == 1 then
			in_game_options.music_level = in_game_options.music_level + 1
			in_game_options.music:vol(in_game_options.music_level * 10)
			clamp_level()
		elseif bar == 2 then
			in_game_options.effects_level = in_game_options.effects_level + 1
			in_game_options.footstep:vol(in_game_options.effects_level * 10)
			in_game_options.jumpsound:vol(in_game_options.effects_level * 10)
			clamp_level()
		elseif bar == 3 then
			in_game_options.menu_level = in_game_options.menu_level + 1
			in_game_options.menusound:vol(in_game_options.menu_level * 10)
			clamp_level()
		end
	end
end

function in_game_options.update()
	if buttons.released.down then
		in_game_options.active = in_game_options.active + 1
		in_game_options.menusound:play(2)
		clamp_actives()
	end
	if buttons.released.up then
		in_game_options.active = in_game_options.active - 1
		in_game_options.menusound:play(2)
		clamp_actives()
	end

	if buttons.released.circle then
		in_game_options.menusound:play(2)
		state_machine.change_state("PAUSE")
	end

	change_volume(in_game_options.active)
end

local function render_music_bar()
	for i = 1, 10 do
		if in_game_options.music_level >= i then
			in_game_options.volume_big:blit(i * 16 + 150, 80)
		else
			in_game_options.volume_small:blit(i * 16 + 150, 80)
		end
	end

	in_game_options.labels[1]:blit(200, 55)

	if in_game_options.active == 1 then
		in_game_options.arrows_active[1]:blit(150, 80)
		in_game_options.arrows_active[2]:blit(326, 80)
	else
		in_game_options.arrows_idle[1]:blit(150, 80)
		in_game_options.arrows_idle[2]:blit(326, 80)
	end
end

local function render_effects_bar()
	for i = 1, 10 do
		if in_game_options.effects_level >= i then
			in_game_options.volume_big:blit(i * 16 + 150, 130)
		else
			in_game_options.volume_small:blit(i * 16 + 150, 130)
		end
	end

	in_game_options.labels[2]:blit(200, 105)

	if in_game_options.active == 2 then
		in_game_options.arrows_active[1]:blit(150, 130)
		in_game_options.arrows_active[2]:blit(326, 130)
	else
		in_game_options.arrows_idle[1]:blit(150, 130)
		in_game_options.arrows_idle[2]:blit(326, 130)
	end
end

local function render_menu_bar()
	for i = 1, 10 do
		if in_game_options.menu_level >= i then
			in_game_options.volume_big:blit(i * 16 + 150, 180)
		else
			in_game_options.volume_small:blit(i * 16 + 150, 180)
		end
	end

	in_game_options.labels[3]:blit(200, 155)

	if in_game_options.active == 3 then
		in_game_options.arrows_active[1]:blit(150, 180)
		in_game_options.arrows_active[2]:blit(326, 180)
	else
		in_game_options.arrows_idle[1]:blit(150, 180)
		in_game_options.arrows_idle[2]:blit(326, 180)
	end
end

function in_game_options.render()
	in_game_options.background:blit(0, 0)

	in_game_options.labels[4]:blit(215, 250)

	render_music_bar()
	render_effects_bar()
	render_menu_bar()
end

return in_game_options
