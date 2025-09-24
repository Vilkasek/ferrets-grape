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

local ONE_WAY_PLATFORM_IDS = { 25, 26, 27 }

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

local function is_one_way_platform(tile_id)
	if not tile_id then
		return false
	end

	for _, platform_id in ipairs(ONE_WAY_PLATFORM_IDS) do
		if tile_id == platform_id then
			return true
		end
	end
	return false
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

	return tile_id ~= 0 and tile_id ~= 24 and tile_id ~= 25 and tile_id ~= 26
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

function Tilemap.check_one_way_solid(x, y, width, height, vel_y)
	if not x or not y or not width or not height or not vel_y then
		return false, nil
	end

	if vel_y <= 0 then
		return false, nil
	end

	local left_tile = math.floor(x / Tilemap.tilesize) + 1
	local right_tile = math.floor((x + width - 1) / Tilemap.tilesize) + 1
	local top_tile = math.floor(y / Tilemap.tilesize) + 1
	local bottom_tile = math.floor((y + height - 1) / Tilemap.tilesize) + 1

	for tile_y = top_tile, bottom_tile do
		for tile_x = left_tile, right_tile do
			if tile_x >= 1 and tile_x <= Tilemap.map_width and tile_y >= 1 and tile_y <= Tilemap.map_height then
				local tile_id = Tilemap.mapdata[tile_y] and Tilemap.mapdata[tile_y][tile_x]

				if tile_id and is_one_way_platform(tile_id) then
					local tile_top = (tile_y - 1) * Tilemap.tilesize
					local player_bottom_prev = y - vel_y + height

					if player_bottom_prev <= tile_top + 4 then -- 4 pixel tolerance
						return true, tile_y
					end
				end
			end
		end
	end

	return false, nil
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
		if not Tilemap.check_solid(test_x, y, width, height) then
			final_x = test_x
		else
			hit_x = true
		end
	end

	if vel_y ~= 0 then
		local test_y = y + vel_y

		if not Tilemap.check_solid(final_x, test_y, width, height) then
			local one_way_hit, tile_y = Tilemap.check_one_way_solid(final_x, test_y, width, height, vel_y)

			if one_way_hit and vel_y > 0 then
				local tile_top = (tile_y - 1) * Tilemap.tilesize
				final_y = tile_top - height
				hit_y = true
			else
				final_y = test_y
			end
		else
			hit_y = true
		end
	end

	return final_x, final_y, hit_x, hit_y
end

function Tilemap.get_tile_at(x, y)
	if not Tilemap.mapdata then
		return nil
	end

	local tile_x = math.floor(x / Tilemap.tilesize) + 1
	local tile_y = math.floor(y / Tilemap.tilesize) + 1

	if tile_y > 0 and tile_y <= Tilemap.map_height and tile_x > 0 and tile_x <= Tilemap.map_width then
		return Tilemap.mapdata[tile_y][tile_x]
	end

	return nil
end

function Tilemap.is_on_one_way_platform(x, y, width, height)
	if not x or not y or not width or not height then
		return false
	end

	-- Check the tile directly below the player
	local check_y = y + height + 1
	local left_tile = math.floor(x / Tilemap.tilesize) + 1
	local right_tile = math.floor((x + width - 1) / Tilemap.tilesize) + 1
	local tile_y = math.floor(check_y / Tilemap.tilesize) + 1

	for tile_x = left_tile, right_tile do
		if tile_x >= 1 and tile_x <= Tilemap.map_width and tile_y >= 1 and tile_y <= Tilemap.map_height then
			local tile_id = Tilemap.mapdata[tile_y] and Tilemap.mapdata[tile_y][tile_x]
			if tile_id and is_one_way_platform(tile_id) then
				-- Make sure player is actually on top of the platform
				local tile_top = (tile_y - 1) * Tilemap.tilesize
				if y + height <= tile_top + 2 then -- 2 pixel tolerance
					return true
				end
			end
		end
	end

	return false
end

function Tilemap.render()
	if tilemap then
		tilemap:blit(camera.x, camera.y)
	end
end

return Tilemap
