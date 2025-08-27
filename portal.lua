local camera = require("camera")

local Portal = {
	folder_path = "assets/graphics/portal",
	animations = {},
	frame = 1,
	anim_timer = 0,
	anim_speed = 6,
	pos_x = 0,
	pos_y = 0,
	width = 32,
	height = 64,
	is_active = false,
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

function Portal.init()
	Portal.animations = load_animation_frames(Portal.folder_path)
end

function Portal.spawn(x, y)
	Portal.pos_x = x
	Portal.pos_y = y
	Portal.is_active = true
end

function Portal.despawn()
	Portal.is_active = false
end

function Portal.update()
	if not Portal.is_active or #Portal.animations == 0 then
		return
	end

	Portal.anim_timer = Portal.anim_timer + 1

	if Portal.anim_timer >= Portal.anim_speed then
		Portal.anim_timer = 0
		Portal.frame = Portal.frame + 1

		if Portal.frame > #Portal.animations then
			Portal.frame = 1
		end
	end
end

function Portal.render()
	if not Portal.is_active or #Portal.animations == 0 then
		return
	end

	local current_frame_image = Portal.animations[Portal.frame]
	if current_frame_image then
		current_frame_image:blit(Portal.pos_x - camera.x, Portal.pos_y - camera.y)
	end
end

return Portal
