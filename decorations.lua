local Decorations = {
	tileset = nil,
	decoration_data = {},
	tilesize = 32,
	map_width = 0,
	map_height = 0,
}

local decorations_map = nil
local camera = require("camera")

local function load_decoration_tileset(path)
	Decorations.tileset = image.load(path)
end

local function load_decoration_data(decoration_data)
	if not decoration_data then
		return
	end

	Decorations.decoration_data = decoration_data
	Decorations.map_height = #decoration_data or 0

	if Decorations.map_height > 0 and decoration_data[1] then
		Decorations.map_width = #decoration_data[1] or 0
	else
		Decorations.map_width = 0
	end
end

local function create_decoration_map(tileset, decoration_data)
	if tileset and decoration_data then
		decorations_map = map.new(tileset, decoration_data, Decorations.tilesize, Decorations.tilesize)
	end
end

function Decorations.init(tileset_path, decoration_data)
	if not tileset_path or not decoration_data then
		return
	end

	load_decoration_tileset(tileset_path)
	load_decoration_data(decoration_data)
	create_decoration_map(Decorations.tileset, Decorations.decoration_data)
end

function Decorations.render()
	if decorations_map then
		decorations_map:blit(camera.x, camera.y)
	end
end

return Decorations
