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

	pos_x = 100,
	pos_y = 100,

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

function Player.init()
	load_animations()
end

local function update_animation()
	local animation_frames = Player.animations[Player.current_animation]

	if not animation_frames or #animation_frames == 0 then
		return
	end

	Player.anim_timer = Player.anim_timer + 1

	if Player.anim_timer >= Player.anim_speed then
		Player.anim_timer = 0
		Player.frame = Player.frame + 1

		if Player.frame > #animation_frames then
			Player.frame = 1
		end
	end
end

function Player.update()
	update_animation()
end

function Player.render()
	local animation_frames = Player.animations[Player.current_animation]

	if animation_frames and #animation_frames > 0 and Player.frame <= #animation_frames then
		local current_frame_image = animation_frames[Player.frame]

		if current_frame_image then
			current_frame_image:blit(Player.pos_x, Player.pos_y)
		end
	end
end

return Player
