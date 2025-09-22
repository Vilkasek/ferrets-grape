local camera = require("camera")
local math = require("math")

local tutorial = {
	dpad_paths = {
		"./assets/graphics/hints/dpad_idle.png",
		"./assets/graphics/hints/dpad_left.png",
		"./assets/graphics/hints/dpad_right.png",
	},
	jump_paths = {
		"./assets/graphics/hints/jump_idle.png",
		"./assets/graphics/hints/jump_active.png",
	},

	dpad = nil,
	jump = nil,

	dpad_index = 1,
	dpad_time = 0.1,

	jump_index = 1,
	jump_time = 0.1,
}

function tutorial.init()
	tutorial.dpad = {
		image.load(tutorial.dpad_paths[1]),
		image.load(tutorial.dpad_paths[2]),
		image.load(tutorial.dpad_paths[3]),
	}
	tutorial.jump = {
		image.load(tutorial.jump_paths[1]),
		image.load(tutorial.jump_paths[2]),
	}
end

local function update_dpad_animation()
	tutorial.dpad_index = tutorial.dpad_index + tutorial.dpad_time
	if tutorial.dpad_index >= 4 then
		tutorial.dpad_index = 1
	end
end

local function update_jump_animation()
	tutorial.jump_index = tutorial.jump_index + tutorial.jump_time
	if tutorial.jump_index >= 2 then
		tutorial.jump_index = 1
	end
end

function tutorial.update()
	update_dpad_animation()
	update_jump_animation()
end

function tutorial.render()
	tutorial.dpad[math.floor(tutorial.dpad_index)]:blit(-camera.x + 64, -camera.y + 100)
	tutorial.jump[math.floor(tutorial.jump_index)]:blit(-camera.x + 256, -camera.y + 100)
end

return tutorial
