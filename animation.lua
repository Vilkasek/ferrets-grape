local level_manager = require("level_manager")
local math = require("math")

local animation = {
	animations = {
		first = {},
	},
	animation_index = 1,
	animation_speed = 0.2,
}

local function load_images_from_folder(path)
	local imgs = {}
	local list = files.list(path)

	for i = 1, #list do
		local f = list[i]
		if not f.directory then
			local name = string.lower(f.name)
			if name:match("%.png$") or name:match("%.jpg$") then
				local img = image.load(path .. f.name)
				if img then
					table.insert(imgs, img)
				end
			end
		end
	end

	return imgs
end

function animation.init()
	animation.animations.first = load_images_from_folder("./assets/graphics/cutscenes/first_animation/")
end

local function update_first(player, tilemap, decorations, camera, state_machine)
	animation.animation_index = animation.animation_index + animation.animation_speed
	if animation.animation_index >= #animation.animations.first then
		level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine)
		state_machine.change_state("GAME")
	end
end

function animation.update(player, tilemap, decorations, camera, state_machine)
	update_first(player, tilemap, decorations, camera, state_machine)
end

function animation.render()
	animation.animations.first[math.floor(animation.animation_index)]:blit(0, 0)
end

return animation
