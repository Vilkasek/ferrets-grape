local Tilemap = {
	tileset = "",
	mapdata = {},
	tilesize = 32,
}

local tilemap

local function load_tileset(path)
	Tilemap.tileset = image.load(path)
end

local function load_data(mapdata)
	Tilemap.mapdata = mapdata
end

local function load_map(tileset, mapdata)
	tilemap = map.new(tileset, mapdata, Tilemap.tilesize, Tilemap.tilesize)
end

function Tilemap.init(path, mapdata)
	load_tileset(path)
	load_data(mapdata)
	load_map(Tilemap.tileset, Tilemap.mapdata)
end

function Tilemap.render()
	tilemap:blit(0, 0)
end

return Tilemap
