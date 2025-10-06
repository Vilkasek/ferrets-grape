local level_manager = require("level_manager")

local hud = {
	pos_x = 0,
	pos_y = 10,

	purple_full_path = "./assets/graphics/hud/purple_full.png",
	red_full_path = "./assets/graphics/hud/red_full.png",
	empty_path = "./assets/graphics/hud/empty.png",

	purple_full = nil,
	red_full = nil,
	empty = nil,
}

function hud.init()
	hud.purple_full = image.load(hud.purple_full_path)
	hud.red_full = image.load(hud.red_full_path)
	hud.empty = image.load(hud.empty_path)
end

local function render_purple(player)
	for i = 1, 3 do
		if player.lives >= i then
			hud.purple_full:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
		else
			hud.empty:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
		end
	end
end

local function render_red(player)
	for i = 1, 3 do
		if player.lives >= i then
			hud.red_full:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
		else
			hud.empty:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
		end
	end
end

function hud.render(player)
	if
		level_manager.current_level_index == 2
		or level_manager.current_level_index == 5
		or level_manager.current_level_index == 8
		or level_manager.current_level_index == 9
		or level_manager.current_level_index == 10
		or level_manager.current_level_index == 11
	then
		render_red(player)
	else
		render_purple(player)
	end
end

return hud
