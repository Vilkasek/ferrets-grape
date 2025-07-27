local Tilemap = {
	tileset = "",
	mapdata = {},
	tilesize = 32,
}

local function load_tileset(path)
  Tilemap.tileset = image.load(path)
end

local function load_data(mapdata)
  Tilemap.mapdata = mapdata
end

function Tilemap.init(path, mapdata)
  load_tileset(path)
  load_data(mapdata)
end
function Tilemap.render() end

return Tilemap
