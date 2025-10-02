local level_manager = require("level_manager")

local animation = {
  buffer = {},
  buffer_size = 10,

  display_frame_index = 1,
  highest_loaded_frame = 0,

  total_frames = 278,
  animation_speed = 0.4,
  base_path = "./assets/graphics/cutscenes/first_animation/",
}

function animation.init()
  animation.buffer = {}
  animation.display_frame_index = 1
  animation.highest_loaded_frame = 0

  for i = 1, animation.buffer_size do
    if i <= animation.total_frames then
      local path = animation.base_path .. i .. ".png"
      local buffer_index = ((i - 1) % animation.buffer_size) + 1
      animation.buffer[buffer_index] = image.load(path)
      animation.highest_loaded_frame = i
    end
  end
end

function animation.update(player, tilemap, decorations, camera, state_machine)
  animation.display_frame_index = animation.display_frame_index + animation.animation_speed

  local next_needed_frame = math.floor(animation.display_frame_index) + animation.buffer_size - 1
  if
      next_needed_frame > animation.highest_loaded_frame
      and animation.highest_loaded_frame < animation.total_frames
  then
    local frame_to_load = animation.highest_loaded_frame + 1
    local path = animation.base_path .. frame_to_load .. ".png"

    local buffer_index = ((frame_to_load - 1) % animation.buffer_size) + 1

    animation.buffer[buffer_index] = image.load(path)
    animation.highest_loaded_frame = frame_to_load
  end

  if animation.display_frame_index >= animation.total_frames or buttons.released.start then
    animation.cleanup()
    level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine)
    state_machine.change_state("TUTORIAL")
  end
end

function animation.render()
  local frame_to_draw = math.floor(animation.display_frame_index)

  if frame_to_draw > animation.total_frames then
    frame_to_draw = animation.total_frames
  end

  local buffer_index = ((frame_to_draw - 1) % animation.buffer_size) + 1
  local current_image = animation.buffer[buffer_index]

  if current_image then
    current_image:blit(0, 0)
  end
end

function animation.cleanup()
  animation.buffer = {}
  collectgarbage()
end

return animation
