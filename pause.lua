local pause = {
	background_path = "./assets/graphics/backgrounds/menu_background.png",
	background = nil,
}

local state_machine = require("state_machine")

function pause.init()
	pause.background = image.load(pause.background_path)
end

function pause.update()
	if buttons.released.start then
		state_machine.change_state("MENU")
	end
end

function pause.render()
	pause.background:blit(0, 0)
end

return pause
