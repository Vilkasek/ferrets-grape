local Player = {
	animations = {
		idle = {},
		moving = {},
		ascending = {},
		descending = {},
	},
	current_animation = "idle",
	frame = 0,
	anim_timer = 0,
	anim_speed = 8,

	vel_x = 0,
	vel_y = 0,

	pos_x = 0,
	pos_y = 0,

	speed = 20,
}

local function load_animation_frames(folder_path)
	local frames = {}
	local frame_index = 1

	while true do
		local file_path = folder_path .. "/" .. frame_index .. ".png"
		local img = image.load(file_path)

		if img then
			table.insert(frames, img)
			frame_index = frame_index + 1
		else
			break
		end
	end

	return frames
end

local function load_animations()
	Player.animations.idle = load_animation_frames("assets/graphics/player/idle")
	Player.animations.move = load_animation_frames("assets/graphics/player/move")
	Player.animations.ascending = load_animation_frames("assets/graphics/player/ascending")
	Player.animations.descending = load_animation_frames("assets/graphics/player/descending")

	if #Player.animations.idle > 0 then
		Player.current_animation = "idle"
		Player.frame = 1
	end
end

local function init()
	load_animations()
end

return Player
