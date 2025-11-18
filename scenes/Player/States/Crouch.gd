extends State
class_name Crouch

var crouch_let_go_time = 5

func Enter():
	super()
	pass
	crouch_let_go_time = 5
	
func Physics_Update():
	
	print(crouch_let_go_time)
	player.get_node("AnimationPlayer").play("crouch_001")

	#startup
	if (player.frame < 5):
		player.b_reverse()
		player.get_node("AnimationPlayer").seek((3*(player.frame/5))*0.03333333333333333, true)
	else:
		player.get_node("AnimationPlayer").seek(4*0.03333333333333333, true)

	if (!input_dict["down_down"]):
		crouch_let_go_time -= 1
		player.get_node("AnimationPlayer").seek((2*((5-crouch_let_go_time)/5)+4)*0.03333333333333333, true)
	else:
		crouch_let_go_time = 5
	
	player.ground_friction(player.GROUND_FRICTION*4)
	pass
	
	
func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	elif (input_dict["jump_pressed"]):
		Transitioned.emit("Jumpsquat")
	elif (input_dict["right_pressed"] or input_dict["left_pressed"]):
		Transitioned.emit("dashstart")
	elif (input_dict["attack_pressed"]):
		Transitioned.emit("Attack")
	elif (input_dict["shield_pressed"]):
		Transitioned.emit("Shield")
	elif (crouch_let_go_time == 0):
		Transitioned.emit("idle")
