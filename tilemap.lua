local Tilemap = {
	tileset = "",
	mapdata = {},
	tilesize = 32,
	map_width = 0,
	map_height = 0,
}

local tilemap

local camera = require("camera")
local math = require("math")

local function load_tileset(path)
	Tilemap.tileset = image.load(path)
end

local function load_data(mapdata)
	Tilemap.mapdata = mapdata
	Tilemap.map_height = #mapdata or 0
	if Tilemap.map_height > 0 and mapdata[1] then
		Tilemap.map_width = #mapdata[1] or 0
	else
		Tilemap.map_width = 0
	end
end

local function load_map(tileset, mapdata)
	tilemap = map.new(tileset, mapdata, Tilemap.tilesize, Tilemap.tilesize)
end

function Tilemap.init(path, mapdata)
	if not mapdata then
		return
	end

	load_tileset(path)
	load_data(mapdata)
	load_map(Tilemap.tileset, Tilemap.mapdata)
end

local function is_tile_solid(tile_x, tile_y)
	if tile_x < 1 or tile_x > Tilemap.map_width or tile_y < 1 or tile_y > Tilemap.map_height then
		return true
	end

	if not Tilemap.mapdata or not Tilemap.mapdata[tile_y] then
		return true
	end

	local tile_id = Tilemap.mapdata[tile_y][tile_x]
	if not tile_id then
		return true
	end

	return tile_id ~= 0 and tile_id ~= 1
end

function Tilemap.check_solid(x, y, width, height)
	if not x or not y or not width or not height then
		return false
	end

	local left_tile = math.floor(x / Tilemap.tilesize) + 1
	local right_tile = math.floor((x + width - 1) / Tilemap.tilesize) + 1
	local top_tile = math.floor(y / Tilemap.tilesize) + 1
	local bottom_tile = math.floor((y + height - 1) / Tilemap.tilesize) + 1

	for tile_y = top_tile, bottom_tile do
		for tile_x = left_tile, right_tile do
			if is_tile_solid(tile_x, tile_y) then
				return true
			end
		end
	end

	return false
end

function Tilemap.resolve_collision(x, y, facing_right, width, height, vel_x, vel_y)
	if not x or not y or not width or not height or not vel_x or not vel_y then
		return x or 0, y or 0, false, false
	end

	local final_x = x
	local final_y = y
	local hit_x = false
	local hit_y = false

	if vel_x ~= 0 then
		local test_x = x + vel_x
		if facing_right then
			if not Tilemap.check_solid(test_x + width, y, width, height) then
				final_x = test_x
			else
				hit_x = true
			end
		else
			if not Tilemap.check_solid(test_x - width, y, width, height) then
				final_x = test_x
			else
				hit_x = true
			end
		end
	end

	if vel_y ~= 0 then
		local test_y = y + vel_y
		if not Tilemap.check_solid(final_x, test_y, width, height) then
			final_y = test_y
		else
			hit_y = true
		end
	end

	return final_x, final_y, hit_x, hit_y
end

function Tilemap.render()
	if tilemap then
		tilemap:blit(camera.x, camera.y)
	end
end

return Tilemap
