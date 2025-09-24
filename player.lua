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

	playjump = false,

	jump_buffer_time = 0,
	jump_buffer_max = 8,
	coyote_time = 0,
	coyote_time_max = 6,
	was_on_ground = false,

	footstep = nil,
	jumpsound = nil,

	last_footstep_time = 0,
	footstep_cooldown = 10,

	drop_through_platform = false,
	drop_through_timer = 0,
	drop_through_max_time = 10,
}

local tilemap = require("tilemap")
local camera = require("camera")
local state_machine = require("state_machine")

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

function Player.init(foot, jump)
	load_animations()
	Player.footstep = foot
	Player.jumpsound = jump
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
			if Player.anim_timer == 0 and Player.last_footstep_time <= 0 then
				sound.play(Player.footstep, 2)
			end
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

local function update_jump_timers()
	if Player.jump_buffer_time > 0 then
		Player.jump_buffer_time = Player.jump_buffer_time - 1
	end

	if Player.was_on_ground and not Player.is_on_ground then
		if Player.coyote_time == 0 then
			Player.coyote_time = Player.coyote_time_max
		end
	end

	if Player.coyote_time > 0 then
		Player.coyote_time = Player.coyote_time - 1
	end

	if Player.is_on_ground then
		Player.coyote_time = 0
	end

	Player.was_on_ground = Player.is_on_ground
end

local function update_drop_through_timer()
	if Player.drop_through_timer > 0 then
		Player.drop_through_timer = Player.drop_through_timer - 1
	else
		Player.drop_through_platform = false
	end
end

local function can_jump()
	return Player.is_on_ground or Player.coyote_time > 0
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
		Player.jump_buffer_time = Player.jump_buffer_max
	end

	if buttons.held.down and Player.is_on_ground then
		if
			tilemap.is_on_one_way_platform
			and tilemap.is_on_one_way_platform(Player.pos_x, Player.pos_y, Player.width, Player.height)
		then
			Player.drop_through_platform = true
			Player.drop_through_timer = Player.drop_through_max_time
			Player.is_on_ground = false
		end
	end

	if buttons.released.start then
		state_machine.change_state("PAUSE")
	end
end

local function handle_jump()
	if Player.jump_buffer_time > 0 and can_jump() and not Player.is_jumping then
		Player.vel_y = -Player.jump_power
		Player.is_jumping = true
		Player.is_on_ground = false

		Player.jump_buffer_time = 0
		Player.coyote_time = 0

		sound.play(Player.jumpsound, 2)
	end
end

local function handle_gravitation()
	Player.vel_y = Player.vel_y + Player.gravity

	if Player.vel_y > 0 then
		Player.is_jumping = false
	end
end

local function resolve_collision_with_one_way(pos_x, pos_y, width, height, vel_x, vel_y)
	if not tilemap or not tilemap.resolve_collision then
		return pos_x, pos_y, false, false
	end

	local final_x = pos_x
	local final_y = pos_y
	local hit_x = false
	local hit_y = false

	-- Handle horizontal movement first
	if vel_x ~= 0 then
		local test_x = pos_x + vel_x * Player.speed
		if not tilemap.check_solid(test_x, pos_y, width, height) then
			final_x = test_x
		else
			hit_x = true
		end
	end

	-- Handle vertical movement
	if vel_y ~= 0 then
		local test_y = pos_y + vel_y

		-- Check solid tiles first
		if not tilemap.check_solid(final_x, test_y, width, height) then
			-- Only check one-way platforms when moving down and not dropping through
			if vel_y > 0 and not Player.drop_through_platform then
				local one_way_hit, tile_y = tilemap.check_one_way_solid(final_x, test_y, width, height, vel_y)

				if one_way_hit then
					-- Position player on top of the one-way platform
					local tile_top = (tile_y - 1) * 32
					final_y = tile_top - height
					hit_y = true
				else
					final_y = test_y
				end
			else
				-- Moving up or dropping through - no one-way collision
				final_y = test_y
			end
		else
			-- Hit a solid tile
			hit_y = true
		end
	end

	return final_x, final_y, hit_x, hit_y
end

local function update_pos()
	handle_input()
	update_jump_timers()
	update_drop_through_timer()
	handle_jump()
	handle_gravitation()

	local vel_x_pixels = (Player.vel_x or 0) * (Player.speed or 7)

	local new_x, new_y, hit_x, hit_y = resolve_collision_with_one_way(
		Player.pos_x or 100,
		Player.pos_y or 100,
		Player.width or 30,
		Player.height or 29,
		Player.vel_x or 0,
		Player.vel_y or 0
	)

	Player.pos_x = new_x
	Player.pos_y = new_y

	if hit_y and Player.vel_y > 0 then
		Player.is_on_ground = true
		Player.vel_y = 0
		Player.is_jumping = false
	elseif hit_y and Player.vel_y < 0 then
		Player.vel_y = 0
	end

	if Player.is_on_ground and Player.vel_y >= 0 and not Player.drop_through_platform then
		-- Check one pixel below the player
		local ground_check_y = Player.pos_y + Player.height + 1

		-- Check for solid ground
		local on_solid_ground = tilemap.check_solid
			and tilemap.check_solid(Player.pos_x, ground_check_y, Player.width, 1)

		-- Check for one-way platform
		local on_one_way = false
		if tilemap.check_one_way_solid then
			local platform_hit, tile_y = tilemap.check_one_way_solid(
				Player.pos_x,
				ground_check_y,
				Player.width,
				1,
				1 -- vel_y = 1 for downward check
			)
			if platform_hit then
				-- Make sure we're actually on top of the platform
				local tile_top = (tile_y - 1) * 32
				if Player.pos_y + Player.height <= tile_top + 2 then
					on_one_way = true
				end
			end
		end

		-- If not on any ground, start falling
		if not on_solid_ground and not on_one_way then
			Player.is_on_ground = false
		end
	end
	if Player.last_footstep_time > 0 then
		Player.last_footstep_time = Player.last_footstep_time - 1
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
			current_frame_image:blit(Player.pos_x - camera.x, Player.pos_y - camera.y)
		end
	end
end

return Player
