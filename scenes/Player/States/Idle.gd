extends State
class_name Idle

func Enter():
	super()
	pass
	
func Physics_Update():
	
	player.get_node("AnimationPlayer").play("idle")


	
	player.ground_friction(player.GROUND_FRICTION)
	pass
	
	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	if (input_dict["jump_pressed"]):
		Transitioned.emit("Jumpsquat")
	elif (input_dict["right_pressed"] or input_dict["left_pressed"]):
		Transitioned.emit("dashstart")
	elif (input_dict["attack_pressed"]):
		Transitioned.emit("Attack")
	elif (input_dict["shield_pressed"]):
		Transitioned.emit("Shield")
