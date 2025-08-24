local levels = require("levels.levels")

local level_manager = {
	background_paths = {
		"./assets/graphics/backgrounds/menu_background.png",
		"./assets/graphics/backgrounds/level1.png",
		"./assets/graphics/backgrounds/level2.png",
	},
	backgrounds = nil,
	current_background = nil,
	current_level_index = 1,
}

function level_manager.init()
	level_manager.backgrounds = {
		image.load(level_manager.background_paths[1]),
		image.load(level_manager.background_paths[2]),
		image.load(level_manager.background_paths[3]),
	}
end

function level_manager.load_level(level_index, player, tilemap, decorations, camera)
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

	level_manager.current_background = level_manager.backgrounds[level_config.background_index]

	player.pos_x = level_config.start_pos.x
	player.pos_y = level_config.start_pos.y
	player.vel_x = 0
	player.vel_y = 0

	camera.x = 0
	camera.y = 0
	camera.update(player, tilemap)

	level_manager.current_level_index = level_index
end

function level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine)
	local player_check_x = player.pos_x + (player.width / 2)
	local player_check_y = player.pos_y + player.height - 1
	local tile_id = tilemap.get_tile_at(player_check_x, player_check_y)

	if tile_id == 99 then
		local next_level = level_manager.current_level_index + 1
		if levels[next_level] then
			level_manager.load_level(next_level, player, tilemap, decorations, camera)
		else
			state_machine.change_state("MENU")
		end
	end
end

function level_manager.get_current_background()
	return level_manager.current_background
end

return level_manager
