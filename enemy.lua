local camera = require("camera")

local Enemy = {
	enemies = {},
	animation_frames = {},
	animation_frames_flipped = {},
	frame_timer = 0,
	frame_speed = 30,
	current_frame = 1,
}

local function load_animation_frames()
	Enemy.animation_frames = {
		image.load("./assets/graphics/enemies/red_bee/1.png"),
		image.load("./assets/graphics/enemies/red_bee/2.png"),
	}

	Enemy.animation_frames_flipped = {
		image.load("./assets/graphics/enemies/red_bee/1.png"),
		image.load("./assets/graphics/enemies/red_bee/2.png"),
	}

	for i = 1, #Enemy.animation_frames_flipped do
		image.fliph(Enemy.animation_frames_flipped[i])
	end
end

function Enemy.init()
	load_animation_frames()
	Enemy.enemies = {}
end

function Enemy.spawn(x, y, speed, range)
	local enemy = {
		pos_x = x,
		pos_y = y,
		width = 20,
		height = 20,
		speed = speed or 1,
		start_x = x,
		range = range,
		direction = -1,
		facing_right = true,
	}
	table.insert(Enemy.enemies, enemy)
end

function Enemy.clear()
	Enemy.enemies = {}
end

local function update_enemy_movement(enemy)
	enemy.pos_x = enemy.pos_x + (enemy.speed * enemy.direction)

	if enemy.direction == 1 then
		if enemy.pos_x >= enemy.start_x + enemy.range then
			enemy.pos_x = enemy.start_x + enemy.range
			enemy.direction = -1
			enemy.facing_right = true
		end
	else
		if enemy.pos_x <= enemy.start_x then
			enemy.pos_x = enemy.start_x
			enemy.direction = 1
			enemy.facing_right = false
		end
	end
end

local function update_animation()
	Enemy.frame_timer = Enemy.frame_timer + 1

	if Enemy.frame_timer >= Enemy.frame_speed then
		Enemy.frame_timer = 0
		Enemy.current_frame = Enemy.current_frame + 1

		if Enemy.current_frame > 2 then
			Enemy.current_frame = 1
		end
	end
end

function Enemy.update()
	update_animation()

	for _, enemy in ipairs(Enemy.enemies) do
		update_enemy_movement(enemy)
	end
end

function Enemy.check_collision(player_x, player_y, player_width, player_height)
	for _, enemy in ipairs(Enemy.enemies) do
		if
			player_x < enemy.pos_x + enemy.width
			and player_x + player_width > enemy.pos_x
			and player_y < enemy.pos_y + enemy.height
			and player_y + player_height > enemy.pos_y
		then
			return true
		end
	end
	return false
end

function Enemy.render()
	if not Enemy.animation_frames[1] or not Enemy.animation_frames[2] then
		return
	end

	for _, enemy in ipairs(Enemy.enemies) do
		local frames = enemy.facing_right and Enemy.animation_frames or Enemy.animation_frames_flipped
		local current_frame_image = frames[Enemy.current_frame]

		if current_frame_image then
			current_frame_image:blit(enemy.pos_x - camera.x, enemy.pos_y - camera.y)
		end
	end
end

return Enemy
