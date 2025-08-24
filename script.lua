local background_paths = {
	"./assets/graphics/backgrounds/menu_background.png",
	"./assets/graphics/backgrounds/level1.png",
	"./assets/graphics/backgrounds/level2.png",
}

local backgrounds = {
	image.load(background_paths[1]),
	image.load(background_paths[2]),
	image.load(background_paths[3]),
}

local state_machine = require("state_machine")

local main_menu = require("main_menu")

local player = require("player")
local tilemap = require("tilemap")
local decorations = require("decorations")
local camera = require("camera")

local levels = require("levels.levels")

local current_level_index = 1
local current_background = nil

local function load_level(level_index)
	local level_config = levels[level_index]
	if not level_config then
		return
	end

	package.loaded[level_config.map_data_path] = nil
	package.loaded[level_config.deco_data_path] = nil

	local mapdata = require(level_config.map_data_path)
	local decodata = require(level_config.deco_data_path)

	tilemap.init(level_config.tileset_path, mapdata)
	decorations.init(level_config.deco_tileset_path, decodata)

	current_background = backgrounds[level_config.background_index]

	player.pos_x = level_config.start_pos.x
	player.pos_y = level_config.start_pos.y
	player.vel_x = 0
	player.vel_y = 0

	camera.x = 0
	camera.y = 0
	camera.update(player, tilemap)

	current_level_index = level_index
end

local music = sound.load("./assets/audio/music/background.wav")
sound.loop(music)
sound.play(music, 1)
sound.vol(music, 50)

local idle_paths = {
	"./assets/graphics/menu/start_idle.png",
	"./assets/graphics/menu/continue_idle.png",
	"./assets/graphics/menu/options_idle.png",
}
local active_paths = {
	"./assets/graphics/menu/start_active.png",
	"./assets/graphics/menu/continue_active.png",
	"./assets/graphics/menu/options_active.png",
}
local idles = { image.load(idle_paths[1]), image.load(idle_paths[2]), image.load(idle_paths[3]) }
local actives = { image.load(active_paths[1]), image.load(active_paths[2]), image.load(active_paths[3]) }

player.init()
main_menu.init()

local state = "MENU"
local activable = { "START", "CONTINUE", "OPTIONS" }
local active = 1

local function clamp_actives()
	if active > #activable then
		active = 1
	elseif active < 1 then
		active = #activable
	end
end

local function update_menu()
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
		load_level(1)
	end
end

local function check_level_transition()
	local player_check_x = player.pos_x + (player.width / 2)
	local player_check_y = player.pos_y + player.height - 1
	local tile_id = tilemap.get_tile_at(player_check_x, player_check_y)

	if tile_id == 99 then
		local next_level = current_level_index + 1
		if levels[next_level] then
			load_level(next_level)
		else
			state_machine.change_state("MENU")
		end
	end
end

local ui_x = 200
local function render_menu()
	if active == 1 then
		actives[1]:blit(ui_x, 100)
		idles[2]:blit(ui_x, 150)
		idles[3]:blit(ui_x, 200)
	elseif active == 2 then
		idles[1]:blit(ui_x, 100)
		actives[2]:blit(ui_x, 150)
		idles[3]:blit(ui_x, 200)
	elseif active == 3 then
		idles[1]:blit(ui_x, 100)
		idles[2]:blit(ui_x, 150)
		actives[3]:blit(ui_x, 200)
	end
end

local function update()
	buttons.read()
	if state_machine.get_state() == "MENU" then
		main_menu.update()
	elseif state_machine.get_state() == "GAME" then
		player.update()
		camera.update(player, tilemap)
		check_level_transition()
	end
end

local function render()
	if state_machine.get_state() == "MENU" then
		image.blit(backgrounds[1], 0, 0)
		main_menu.render()
	elseif state_machine.get_state() == "GAME" then
		if current_background then
			image.blit(current_background, 0, 0)
		end
		tilemap.render()
		decorations.render()
		player.render()
	end
	screen.flip()
end

while true do
	update()
	render()
end
