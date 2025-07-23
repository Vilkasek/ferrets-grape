local background_paths = {
	"./assets/graphics/backgrounds/level1.png",
	"./assets/graphics/backgrounds/level2.png",
}

local backgrounds = {
	image.load(background_paths[1]),
	image.load(background_paths[2]),
}

while true do
	image.blit(backgrounds[1], 0, 0)

	screen.flip()
end
