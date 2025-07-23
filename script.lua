local player = require("player")

local background_paths = {
	"./assets/graphics/backgrounds/level1.png",
	"./assets/graphics/backgrounds/level2.png",
}

local backgrounds = {
	image.load(background_paths[1]),
	image.load(background_paths[2]),
}

player.init()

local function update()
	player.update()
end

local function render()
	image.blit(backgrounds[1], 0, 0)

	player.render()

	screen.flip()
end

while true do
	update()
	render()
end
