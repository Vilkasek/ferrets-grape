local camera = {
	x = 0,
	y = 0,
	smoothing = 0.1,
}

local SCREEN_WIDTH = 480
local SCREEN_HEIGHT = 272

function camera.update(player, tilemap)
	local target_x = player.pos_x + (player.width / 2) - (SCREEN_WIDTH / 2)
	local target_y = player.pos_y + (player.height / 2) - (SCREEN_HEIGHT / 2)

	camera.x = camera.x + (target_x - camera.x) * camera.smoothing
	camera.y = camera.y + (target_y - camera.y) * camera.smoothing

	camera.x = math.floor(camera.x)
	camera.y = math.floor(camera.y)

	if camera.x <= 0 then
		camera.x = 0
	end

	if camera.y <= 0 then
		camera.y = 0
	end

	local map_width_pixels = tilemap.map_width * tilemap.tilesize
	if camera.x + SCREEN_WIDTH >= map_width_pixels then
		camera.x = map_width_pixels - SCREEN_WIDTH
	end

	local map_height_pixels = tilemap.map_height * tilemap.tilesize
	if camera.y + SCREEN_HEIGHT >= map_height_pixels then
		camera.y = map_height_pixels - SCREEN_HEIGHT
	end
end

return camera
