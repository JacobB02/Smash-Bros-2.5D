extends State
class_name Jump

func Enter():
	super()
	inputs.clear_buffer("up_pressed") 
	pass
	
func Physics_Update():
	player.air_physics()
	
	player.get_node("AnimationPlayer").play("jump")
	#player.get_node("AnimationPlayer").seek(1)


func Transition_Check():
	if player.is_on_floor():
		Transitioned.emit("land")
	if (input_dict["jump_pressed"]):
		Transitioned.emit("DoubleJump")
	if (input_dict["shield_pressed"]):
		Transitioned.emit("Shield")
