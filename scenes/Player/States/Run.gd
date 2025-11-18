extends State
class_name Run




func Enter():
	super()
	
	player.get_node("AnimationPlayer").play("run_001")
	#player.get_node("AnimationPlayer").pause()
	

func Physics_Update():
	#sprite.play("DashStart")
	#sprite.set_frame(parent.frame*sprite.sprite_frames.get_frame_count(sprite.get_animation())/parent.DASH_START_LENGTH)
	player.ground_friction(player.GROUND_FRICTION)
	player.velocity.x = player.RUNSPEED*player.dir
	
	#player.get_node("AnimationPlayer").play("run", -1, 1)
#	player.get_node("AnimationPlayer").seek(15/60, 1, 1)

	player.get_node("AnimationPlayer").seek(((player.frame/4)%14)*0.03333333333333333, true)
	
	#print(player.frame)
	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	elif (input_dict["jump_pressed"]):
		Transitioned.emit("jumpsquat")
	elif ((player.dir == 1 and input_dict["left_down"]) or (player.dir == -1 and input_dict["right_down"])):
		Transitioned.emit("dashstart")
	elif (!input_dict["right_down"] and !input_dict["left_down"]):
		Transitioned.emit("idle")
		
	#elif (player.input_dict["down_down"]):
		#Transitioned.emit("crouch")
	#elif (player.input_dict["attack_pressed"]):
		#Transitioned.emit("attack")
	
