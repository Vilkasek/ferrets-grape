local state_machine = require("state_machine")
local level_manager = require("level_manager")
local main_menu = require("main_menu")
local player = require("player")
local tilemap = require("tilemap")
local decorations = require("decorations")
local camera = require("camera")
local options = require("options")
local portal = require("portal")
local pause = require("pause")

local music = sound.load("./assets/audio/music/background.wav")
local footstep = sound.load("./assets/audio/sounds/footstep.wav")
local jumpsound = sound.load("./assets/audio/sounds/jump.wav")
local menu = sound.load("./assets/audio/sounds/menu.wav")

main_menu.init(menu)
player.init(footstep, jumpsound)
level_manager.init()
portal.init()
options.init(footstep, jumpsound, music, menu)
pause.init()

sound.loop(music)
sound.play(music, 1)
sound.vol(music, 50)

local function update()
	buttons.read()

	if state_machine.get_state() == "MENU" then
		main_menu.update()
	elseif state_machine.get_state() == "GAME" then
		player.update()
		portal.update()
		camera.update(player, tilemap)
		level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine)
	elseif state_machine.get_state() == "OPTIONS" then
		options.update()
	elseif state_machine.get_state() == "PAUSE" then
		pause.update()
	end
end

local function render()
	if state_machine.get_state() == "MENU" then
		local menu_bg = level_manager.backgrounds[1]
		if menu_bg then
			image.blit(menu_bg, 0, 0)
		end
		main_menu.render()
	elseif state_machine.get_state() == "GAME" then
		local current_background = level_manager.get_current_background()
		if current_background then
			image.blit(current_background, 0, 0)
		end
		tilemap.render()
		decorations.render()
		portal.render()
		player.render()
	elseif state_machine.get_state() == "OPTIONS" then
		options.render()
	elseif state_machine.get_state() == "PAUSE" then
		pause.render()
	end
	screen.flip()
end

while true do
	update()
	render()
end
