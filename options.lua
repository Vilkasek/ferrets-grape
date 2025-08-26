local state_machine = require("state_machine")

local options = {
	volume_big_path = "./assets/graphics/options/volume_big.png",
	volume_small_path = "./assets/graphics/options/volume_small.png",

	background_path = "./assets/graphics/backgrounds/menu_background.png",

	volume_big = nil,
	volume_small = nil,

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

function options.render()
	background:blit(0, 0)

	screen.print(100, 50, "Music", 1, color.new(0, 0, 0))

	for i = 1, 10 do
		if options.music_level >= i then
			options.volume_big:blit(i * 16 + 150, 80)
		else
			options.volume_small:blit(i * 16 + 150, 80)
		end
	end

	screen.print(100, 120, "Sounds", 1, color.new(0, 0, 0))

	for i = 1, 10 do
		if options.effects_level >= i then
			options.volume_big:blit(i * 16 + 150, 120)
		else
			options.volume_small:blit(i * 16 + 150, 120)
		end
	end

	screen.print(100, 140, "Menu", 1, color.new(0, 0, 0))

	for i = 1, 10 do
		if options.menu_level >= i then
			options.volume_big:blit(i * 16 + 150, 160)
		else
			options.volume_small:blit(i * 16 + 150, 160)
		end
	end
end

return options
