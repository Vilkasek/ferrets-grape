local backgrounds = {
	"./assets/graphics/backgrounds/level1.png",
	"./assets/graphics/backgrounds/level2.png",
}

local background = image.load(backgrounds[1])

while true do
	image.blit(background, 0, 0)

	screen.flip()
end
