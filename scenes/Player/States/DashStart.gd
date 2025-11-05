extends State
class_name Dash_Start


#hi. I need to add a DASHTURN even if its brief so that I can do RAR

func Enter():
	super()
	
	print("IN DASH START ENTER")
	print(str(state_machine.prev_state.name))

	if (state_machine.prev_state.name == "land" or state_machine.prev_state.name == "idle_air" or state_machine.prev_state.name == "double_jump" or state_machine.prev_state.name == "landing_lag"):
		if (input_dict["right_down"] > input_dict["left_down"]):
			player.dir = 1
		elif (input_dict["right_down"] < input_dict["left_down"]):
			player.dir = -1
	else:
		if (input_dict["right_pressed"] > input_dict["left_pressed"]):
			player.dir = 1
		elif (input_dict["right_pressed"] < input_dict["left_pressed"]):
			player.dir = -1
		inputs.clear_buffer("left_pressed") 
		inputs.clear_buffer("right_pressed")
	
	print("TESTING" + str(input_dict["right_down"]) + str(input_dict["left_down"]) )
	
	#sprite.play("DashStart")
	#sprite.set_frame(player.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/player.DASH_START_LENGTH)
	player.velocity.x = player.DASHSPEED*player.dir


func Physics_Update():
	#sprite.play("DashStart")
	#sprite.set_frame(parent.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/parent.DASH_START_LENGTH)
	player.ground_friction(player.GROUND_FRICTION)
	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	elif (input_dict["jump_pressed"]):
		Transitioned.emit("jumpsquat")
	elif (input_dict["right_pressed"] or input_dict["left_pressed"]):
		Transitioned.emit("dashstart")
	elif (player.frame >= player.DASH_START_LENGTH and !input_dict["right_down"] and !input_dict["left_down"]):
		Transitioned.emit("idle")
	elif (player.frame >= player.DASH_START_LENGTH):
		Transitioned.emit("run")
	#elif (player.input_dict["down_down"]):
		#Transitioned.emit("crouch")
	#elif (player.input_dict["attack_pressed"]):
		#Transitioned.emit("attack")
	
