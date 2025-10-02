local level_manager = require("level_manager")

local animation = {
	current_frame = 1,
	total_frames = 278,
	animation_speed = 0.2,
	base_path = "./assets/graphics/cutscenes/first/",
	current_image = nil,
}

function animation.update(player, tilemap, decorations, camera, state_machine)
	animation.current_frame = animation.current_frame + animation.animation_speed

	if animation.current_frame >= animation.total_frames then
		level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine)
		state_machine.change_state("GAME")
	end
end

function animation.render()
	if animation.current_image then
		image.free(animation.current_image)
	end

	local frame_num = math.floor(animation.current_frame)
	animation.current_image = image.load(animation.base_path .. frame_num .. ".png")

	if animation.current_image then
		animation.current_image:blit(0, 0)
	end
end
