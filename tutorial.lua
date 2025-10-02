local math = require("math")
local state_machine = require("state_machine")

local tutorial = {
	animation_path = "./assets/graphics/tutorial/",
	animation = nil,
	animation_time = 0.1,
	frame = 1,

  label_path = "./assets/graphics/tutorial/continue.png",
  label = nil,
}

function tutorial.init()
	tutorial.animation = {
		image.load(tutorial.animation_path .. "1.png"),
		image.load(tutorial.animation_path .. "2.png"),
		image.load(tutorial.animation_path .. "3.png"),
		image.load(tutorial.animation_path .. "4.png"),
	}

  tutorial.label = image.load(tutorial.label_path)
end

local function handle_input()
  if buttons.released.cross then
    state_machine.change_state("GAME")
  end
end

function tutorial.update()
  handle_input()

	tutorial.frame = tutorial.frame + tutorial.animation_time
	if tutorial.frame >= 4.9 then
		tutorial.frame = 1
	end
end

function tutorial.render()
	tutorial.animation[math.floor(tutorial.frame)]:blit(0, 0)
  tutorial.label:blit(480/2-32, 235)
end

return tutorial
