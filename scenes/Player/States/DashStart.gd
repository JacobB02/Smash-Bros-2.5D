extends State
class_name Dash_Start


#hi. I need to add a DASHTURN even if its brief so that I can do RAR

func Enter():
	super()
	
	player.get_node("AnimationPlayer").play("run")
	
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
		inputs.clear_buffer("down_pressed") #for crouch
	
	print("TESTING" + str(input_dict["right_down"]) + str(input_dict["left_down"]) )
	
	#sprite.play("DashStart")
	#sprite.set_frame(player.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/player.DASH_START_LENGTH)
	player.velocity.x = (abs(player.velocity.x)+3)*player.dir #(player.DASHSPEED*player.dir ) #- 4 + player.frame/10)*player.dir 


func Physics_Update():
	
	#print(player.frame)
	
	player.get_node("AnimationPlayer").play("run_001", -1, 0)
	player.get_node("AnimationPlayer").seek(((player.frame/4)%14)*0.03333333333333333, true)
	#print(28/30)
	#print(floor(player.frame/4))
	#print(player.frame)
	
	#sprite.play("DashStart")
	#sprite.set_frame(parent.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/parent.DASH_START_LENGTH)
	#player.ground_friction(player.GROUND_FRICTION)
	if (input_dict["right_down"] and player.dir == 1):
		player.velocity.x = clamp(player.velocity.x + 0.5, -1*player.DASHSPEED, player.DASHSPEED)
	elif (input_dict["left_down"] and player.dir == -1):
		player.velocity.x = clamp(player.velocity.x - 0.5, -1*player.DASHSPEED, player.DASHSPEED)
	 #(player.DASHSPEED*player.dir) # - 4 + player.frame/10)*player.dir 

	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	elif (input_dict["jump_pressed"]):
		Transitioned.emit("jumpsquat")
	
	elif (input_dict["down_pressed"]):
		Transitioned.emit("crouch")
		
	elif ((input_dict["right_pressed"] and player.dir == -1) 
	or (input_dict["left_pressed"] and player.dir == 1)):
		Transitioned.emit("dashturn")
		
		
	elif ((player.frame > player.DASH_START_LENGTH and ((input_dict["right_pressed"] and player.dir == 1) 
	or (input_dict["left_pressed"] and player.dir == -1)))):
		Transitioned.emit("dashstart")
		
	elif (player.frame > player.DASH_START_LENGTH and !input_dict["right_down"] and !input_dict["left_down"]):
		Transitioned.emit("dashstop")
	elif (player.frame == player.DASH_START_LENGTH and input_dict["down_down"]):
		Transitioned.emit("crouch")
	
	elif (player.frame == player.DASH_START_LENGTH and ((!input_dict["right_down"] and player.dir == 1) or (!input_dict["left_down"] and player.dir == -1))):
		Transitioned.emit("idle")
		
		
	
	#elif (player.input_dict["down_down"]):
		#Transitioned.emit("crouch")
	#elif (player.input_dict["attack_pressed"]):
		#Transitioned.emit("attack")
	
