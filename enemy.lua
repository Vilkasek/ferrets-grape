local enemy = {
	dir_path = nil,
	animation = {},
	frame = 0,
	anim_timer = 0,
	anim_speed = 4,
}

function enemy.init(path)
	enemy.dir_path = path
end

local function update_animation()
	local animation_frames = enemy.animation

	if not animation_frames or #animation_frames == 0 then
		return
	end

	enemy.anim_timer = enemy.anim_timer + 1

	if enemy.anim_timer >= enemy.anim_speed then
		enemy.anim_timer = 0
		enemy.frame = enemy.frame + 1

		if enemy.frame > #animation_frames then
			enemy.frame = 1
		end
	end
end

function enemy.update()
	update_animation()
end

function enemy.render(pos_x, pos_y)
	local animation_frames = enemy.animation

	if animation_frames and #animation_frames > 0 and enemy.frame <= #animation_frames then
		local current_frame_image = animation_frames[enemy.frame]

		if current_frame_image then
			current_frame_image:blit(pos_x, pos_y)
		end
	end
end

return enemy
