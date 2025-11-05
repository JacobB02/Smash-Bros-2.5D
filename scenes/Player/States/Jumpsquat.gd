extends State
class_name Jumpsquat

func Enter():
	super()
	inputs.clear_buffer("jump_pressed") 
	inputs.clear_buffer("shield_pressed") 
	pass
	
func Physics_Update():
	#if (state_machine.prev_state.name == "DashStart"):
	player.b_reverse()
		
	
	

func Exit():
	if (state_machine.prev_state.name != "DashStart" and 
	state_machine.prev_state.name != "Run"):
		if (player.input_dict["right_down"] > player.input_dict["left_down"]):
			player.velocity.x = max(player.JUMP_CHANGE, player.velocity.x)
			#player.velocity.x = clamp(player.velocity.x+player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
		elif (player.input_dict["right_down"] < player.input_dict["left_down"]):
			player.velocity.x = min(-player.JUMP_CHANGE, player.velocity.x)
			#player.velocity.x = clamp(player.velocity.x-player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
		
	
	#check if jump is being held down
	if (player.input_dict["jump_down"]):
		player.velocity.y = player.JUMP_START_VELOCITY
		player.in_first_jump = 5
	else:
		player.velocity.y = player.SHORTHOP_START_VELOCITY
	
	
func Transition_Check():
	if (player.frame >= player.JUMP_START_LENGTH):
		Transitioned.emit("jump")
