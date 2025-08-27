local state_machine = require("state_machine")

local options = {
	volume_big_path = "./assets/graphics/options/volume_big.png",
	volume_small_path = "./assets/graphics/options/volume_small.png",

	background_path = "./assets/graphics/backgrounds/menu_background.png",

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

function options.init(foot, jump, m, mn)
	options.background = image.load(options.background_path)

	options.volume_big = image.load(options.volume_big_path)
	options.volume_small = image.load(options.volume_small_path)
	options.background = image.load(options.background_path)

	options.footstep = foot
	options.jumpsound = jump
	options.music = m
	options.menusound = mn

	options.arrows_idle = { image.load(options.arrows_idle_paths[1]), image.load(options.arrows_idle_paths[2]) }
	options.arrows_active = { image.load(options.arrows_active_paths[1]), image.load(options.arrows_active_paths[2]) }

	options.labels = {
		image.load(options.labels_paths[1]),
		image.load(options.labels_paths[2]),
		image.load(options.labels_paths[3]),
		image.load(options.labels_paths[4]),
	}
end

local function clamp_actives()
	if options.active > #options.activable then
		options.active = 1
	elseif options.active < 1 then
		options.active = #options.activable
	end
end

local function clamp_level()
	if options.music_level <= 0 then
		options.music_level = 0
	elseif options.music_level >= 10 then
		options.music_level = 10
	end

	if options.effects_level <= 0 then
		options.effects_level = 0
	elseif options.effects_level >= 10 then
		options.effects_level = 10
	end

	if options.menu_level <= 0 then
		options.menu_level = 0
	elseif options.menu_level >= 10 then
		options.menu_level = 10
	end
end

local function change_volume(bar)
	if buttons.released.left then
		if bar == 1 then
			options.music_level = options.music_level - 1
			options.music:vol(options.music_level * 10)
			clamp_level()
		elseif bar == 2 then
			options.effects_level = options.effects_level - 1
			options.footstep:vol(options.effects_level * 10)
			options.jumpsound:vol(options.effects_level * 10)
			clamp_level()
		elseif bar == 3 then
			options.menu_level = options.menu_level - 1
			options.menusound:vol(options.menu_level * 10)
			clamp_level()
		end
	end

	if buttons.released.right then
		if bar == 1 then
			options.music_level = options.music_level + 1
			options.music:vol(options.music_level * 10)
			clamp_level()
		elseif bar == 2 then
			options.effects_level = options.effects_level + 1
			options.footstep:vol(options.effects_level * 10)
			options.jumpsound:vol(options.effects_level * 10)
			clamp_level()
		elseif bar == 3 then
			options.menu_level = options.menu_level + 1
			options.menusound:vol(options.menu_level * 10)
			clamp_level()
		end
	end
end

function options.update()
	if buttons.released.down then
		options.active = options.active + 1
		options.menusound:play(2)
		clamp_actives()
	end
	if buttons.released.up then
		options.active = options.active - 1
		options.menusound:play(2)
		clamp_actives()
	end

	if buttons.released.circle then
		options.menusound:play(2)
		state_machine.change_state("MENU")
	end

	change_volume(options.active)
end

local function render_music_bar()
	for i = 1, 10 do
		if options.music_level >= i then
			options.volume_big:blit(i * 16 + 150, 80)
		else
			options.volume_small:blit(i * 16 + 150, 80)
		end
	end

	options.labels[1]:blit(200, 55)

	if options.active == 1 then
		options.arrows_active[1]:blit(150, 80)
		options.arrows_active[2]:blit(326, 80)
	else
		options.arrows_idle[1]:blit(150, 80)
		options.arrows_idle[2]:blit(326, 80)
	end
end

local function render_effects_bar()
	for i = 1, 10 do
		if options.effects_level >= i then
			options.volume_big:blit(i * 16 + 150, 130)
		else
			options.volume_small:blit(i * 16 + 150, 130)
		end
	end

	options.labels[2]:blit(200, 105)

	if options.active == 2 then
		options.arrows_active[1]:blit(150, 130)
		options.arrows_active[2]:blit(326, 130)
	else
		options.arrows_idle[1]:blit(150, 130)
		options.arrows_idle[2]:blit(326, 130)
	end
end

local function render_menu_bar()
	for i = 1, 10 do
		if options.menu_level >= i then
			options.volume_big:blit(i * 16 + 150, 180)
		else
			options.volume_small:blit(i * 16 + 150, 180)
		end
	end

	options.labels[3]:blit(200, 155)

	if options.active == 3 then
		options.arrows_active[1]:blit(150, 180)
		options.arrows_active[2]:blit(326, 180)
	else
		options.arrows_idle[1]:blit(150, 180)
		options.arrows_idle[2]:blit(326, 180)
	end
end

function options.render()
	options.background:blit(0, 0)

	options.labels[4]:blit(215, 250)

	render_music_bar()
	render_effects_bar()
	render_menu_bar()
end

return options
