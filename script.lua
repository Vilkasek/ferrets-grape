local player = require("player")
local tilemap = require("tilemap")
local camera = require("camera")

local mapdata = require("levels.level1")

local background_paths = {
	"./assets/graphics/backgrounds/level1.png",
	"./assets/graphics/backgrounds/level2.png",
}

local backgrounds = {
	image.load(background_paths[1]),
	image.load(background_paths[2]),
}

player.init()
tilemap.init("./assets/graphics/tilesets/level1.png", mapdata)

local function update()
	buttons.read()

	player.update()
	camera.update(player, tilemap)
end

local function render()
	image.blit(backgrounds[1], 0, 0)

	tilemap.render()
	player.render()

	screen.flip()
end

while true do
	update()
	render()
end
