extends State
class_name Land

func Enter():
	super()
	
	#parent.ground_friction(parent.GROUND_FRICTION)
	#sprite.play("Land")


func Physics_Update():
	player.ground_friction(player.GROUND_FRICTION)
	#sprite.play("Land")



func Transition_Check():
	if !player.is_on_floor():
		Transitioned.emit("jump")
	elif (player.frame >= player.LAND_TIME):
		Transitioned.emit("idle")
	#elif (parent.input_dict["right_down"] or parent.input_dict["left_down"]):
		#Transitioned.emit("dash_start")
	#elif (parent.input_dict["jump_pressed"]):
		#Transitioned.emit("jumpsquat")
	#elif (parent.input_dict["attack_pressed"]):
		#Transitioned.emit("attack")
	
		
