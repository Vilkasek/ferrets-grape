require("utils")

local state_machine = {
	states = {
		"MENU",
		"GAME",
		"OPTIONS",
		"PAUSE",
		"IN_GAME_OPTIONS",
		"TUTORIAL",
		"ANIMATION",
		"GAME_OVER",
	},
	state = "MENU",
}

function state_machine.change_state(st)
	if contains(state_machine.states, st) then
		state_machine.state = st
	else
		state_machine.state = "MENU"
	end
end

function state_machine.get_state()
	return state_machine.state
end

return state_machine
