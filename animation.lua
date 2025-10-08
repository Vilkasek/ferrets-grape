local level_manager = require("level_manager")

local animation = {
	buffer = {},
	buffer_size = 3,

	display_frame_index = 1,
	highest_loaded_frame = 0,

	current_animation_config = nil,

	animations = {
		first = {
			total_frames = 180,
			animation_speed = 0.2,
			base_path = "./assets/graphics/cutscenes/first_animation/",
			next_state = "TUTORIAL",
			load_next_level = false,
		},
		second = {
			total_frames = 91,
			animation_speed = 0.2,
			base_path = "./assets/graphics/cutscenes/second_animation/",
			next_state = "GAME",
			load_next_level = true,
		},
	},

	music = nil,
}

function animation.set_animation(animation_name)
	animation.current_animation_config = animation.animations[animation_name]
	if not animation.current_animation_config then
		animation.current_animation_config = animation.animations.first
	end
end

function animation.init(animation_name, m)
	animation.cleanup()

	animation_name = animation_name or "first"
	animation.set_animation(animation_name)

	animation.buffer = {}
	animation.display_frame_index = 1
	animation.highest_loaded_frame = 0

	for i = 1, animation.buffer_size do
		if i <= animation.current_animation_config.total_frames then
			local path = animation.current_animation_config.base_path .. i .. ".png"
			local buffer_index = ((i - 1) % animation.buffer_size) + 1
			if animation_name == "second" then
				animation.buffer[buffer_index] = image.load(path)
				animation.highest_loaded_frame = i
			end
			animation.buffer[buffer_index] = image.loadv(path)
			animation.highest_loaded_frame = i
		end
	end

	animation.music = m
end

function animation.update(player, tilemap, decorations, camera, state_machine)
	animation.display_frame_index = animation.display_frame_index + animation.current_animation_config.animation_speed

	local next_needed_frame = math.floor(animation.display_frame_index) + animation.buffer_size - 1
	if
		next_needed_frame > animation.highest_loaded_frame
		and animation.highest_loaded_frame < animation.current_animation_config.total_frames
	then
		local frame_to_load = animation.highest_loaded_frame + 1
		local path = animation.current_animation_config.base_path .. frame_to_load .. ".png"

		local buffer_index = ((frame_to_load - 1) % animation.buffer_size) + 1

		animation.buffer[buffer_index] = image.load(path)
		animation.highest_loaded_frame = frame_to_load
	end

	if animation.display_frame_index >= animation.current_animation_config.total_frames or buttons.released.start then
		animation.cleanup()

		if animation.current_animation_config.load_next_level then
			local next_level = level_manager.current_level_index + 1
			local levels = require("levels.levels")

			if levels[next_level] then
				level_manager.load_level(next_level, player, tilemap, decorations, camera)
				state_machine.change_state(animation.current_animation_config.next_state)
			else
				state_machine.change_state("MENU")
			end
		else
			sound.play(animation.music, 1)
			state_machine.change_state(animation.current_animation_config.next_state)
		end
	end
end

function animation.render()
	local frame_to_draw = math.floor(animation.display_frame_index)

	if frame_to_draw > animation.current_animation_config.total_frames then
		frame_to_draw = animation.current_animation_config.total_frames
	end

	local buffer_index = ((frame_to_draw - 1) % animation.buffer_size) + 1
	local current_image = animation.buffer[buffer_index]

	if current_image then
		current_image:blit(0, 0)
	end
end

function animation.cleanup()
	collectgarbage()
	animation.buffer = {}
end

return animation
