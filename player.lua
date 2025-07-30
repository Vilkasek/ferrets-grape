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
	anim_speed = 4,
	facing_right = true,

	vel_x = 0,
	vel_y = 0,

	pos_x = 100,
	pos_y = 100,

	speed = 7,

	is_on_ground = false,
	is_jumping = false,
	jump_power = 10,

	gravity = 0.5,

	height = 29,
	width = 30,
}

local tilemap = require("tilemap")

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
	Player.animations.moving = load_animation_frames("assets/graphics/player/move")
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

local function change_animation(anim_name)
	if Player.current_animation ~= anim_name then
		Player.current_animation = anim_name
		Player.frame = 1
		Player.anim_timer = 0
	end
end

local function determine_animation()
	if Player.is_on_ground then
		if Player.vel_x ~= 0 then
			Player.anim_speed = 8
			change_animation("moving")
		else
			Player.anim_speed = 12
			change_animation("idle")
		end
	else
		if Player.vel_y < 0 then
			change_animation("ascending")
		else
			change_animation("descending")
		end
	end
end

local function update_animation()
	determine_animation()

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

local function flip_all_animations()
	for anim_name, frames in pairs(Player.animations) do
		for _, frame in ipairs(frames) do
			if frame then
				image.fliph(frame)
			end
		end
	end
end

local function handle_input()
	if buttons.held.left then
		Player.vel_x = -1
		if Player.facing_right then
			Player.facing_right = false
			flip_all_animations()
		end
	elseif buttons.held.right then
		Player.vel_x = 1
		if not Player.facing_right then
			Player.facing_right = true
			flip_all_animations()
		end
	else
		Player.vel_x = 0
	end

	if buttons.cross then
		Player.is_jumping = true
	end
end

local function handle_gravitation()
	Player.vel_y = Player.vel_y + Player.gravity

	if Player.is_jumping and Player.is_on_ground then
		Player.vel_y = -Player.jump_power
		Player.is_jumping = false
		Player.is_on_ground = false
	end
end

local function update_pos()
	handle_input()
	handle_gravitation()

	local vel_x_pixels = (Player.vel_x or 0) * (Player.speed or 7)

	if not tilemap or not tilemap.resolve_collision then
		return
	end

	local new_x, new_y, hit_x, hit_y = tilemap.resolve_collision(
		Player.pos_x or 100,
		Player.pos_y or 100,
		Player.facing_right,
		Player.width or 32,
		Player.height or 29,
		vel_x_pixels,
		Player.vel_y or 0
	)

	Player.pos_x = new_x
	Player.pos_y = new_y

	if hit_y and Player.vel_y > 0 then
		Player.is_on_ground = true
		Player.vel_y = 0
	elseif hit_y and Player.vel_y < 0 then
		Player.vel_y = 0
	end

	if Player.is_on_ground and Player.vel_y >= 0 then
		local ground_check_y = Player.pos_y + Player.height + 1
		if not tilemap.check_solid(Player.pos_x, ground_check_y, Player.width, 1) then
			Player.is_on_ground = false
		end
	end
end

function Player.update()
	update_animation()
	update_pos()
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
