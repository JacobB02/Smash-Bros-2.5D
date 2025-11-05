extends State
class_name Jump

func Enter():
	super()
	inputs.clear_buffer("up_pressed") 
	pass
	
func Physics_Update():
	player.air_physics()

func Transition_Check():
	if player.is_on_floor():
		Transitioned.emit("land")
	if (input_dict["jump_pressed"]):
		Transitioned.emit("DoubleJump")
	if (input_dict["shield_pressed"]):
		player.in_first_jump = 0
		Transitioned.emit("Shield")
