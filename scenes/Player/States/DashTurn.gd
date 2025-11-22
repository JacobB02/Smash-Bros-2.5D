extends State
class_name Dash_Turn


#hi. I need to add a DASHTURN even if its brief so that I can do RAR

func Enter():
	super()
	
	player.get_node("AnimationPlayer").play("run")
	
	print("IN DASH TURN")
	print(str(state_machine.prev_state.name))

	player.dir *= -1
	inputs.clear_buffer("left_pressed") 
	inputs.clear_buffer("right_pressed")
	
	print("TESTING" + str(input_dict["right_down"]) + str(input_dict["left_down"]) )
	
	#sprite.play("DashStart")
	#sprite.set_frame(player.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/player.DASH_START_LENGTH)


func Physics_Update():
	
	player.get_node("AnimationPlayer").play("run_001", -1, 0)
	player.get_node("AnimationPlayer").seek(((player.frame/4)%14)*0.03333333333333333, true)
	#print(28/30)
	#print(floor(player.frame/4))
	#print(player.frame)

	#sprite.play("DashStart")
	#sprite.set_frame(parent.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/parent.DASH_START_LENGTH)
	#player.ground_friction(player.)
	
	player.velocity.x += player.DASH_TURN_FRICTION*player.dir
	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
		
	elif (input_dict["jump_pressed"]):
		Transitioned.emit("jumpsquat")
		
	elif (input_dict["down_pressed"]):
		Transitioned.emit("crouch")
		
	elif (player.frame >= player.DASH_TURN_LENGTH 
	and ((input_dict["right_down"] and player.dir == 1) 
	or (input_dict["left_down"] and player.dir == -1))):
		Transitioned.emit("dashstart")
	elif (player.frame >= player.DASH_TURN_LENGTH ):
		Transitioned.emit("idle")
	
	#elif (player.input_dict["down_down"]):
		#Transitioned.emit("crouch")
	#elif (player.input_dict["attack_pressed"]):
		#Transitioned.emit("attack")
	
