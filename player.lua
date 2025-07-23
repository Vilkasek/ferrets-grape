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

return Player
