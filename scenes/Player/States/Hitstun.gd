extends State
class_name Hitstun

func Enter():
	super()
	player.velocity.y = player.JUMPSPEED
	
	if (player.input_dict["right_down"] > player.input_dict["left_down"]):
		player.velocity.x = max(player.DJUMP_CHANGE, player.velocity.x)
		#player.velocity.x = clamp(player.velocity.x+player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
	elif (player.input_dict["right_down"] < player.input_dict["left_down"]):
		player.velocity.x = min(-player.DJUMP_CHANGE, player.velocity.x)
		#player.velocity.x = clamp(player.velocity.x-player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
	
		
	pass
	
func Physics_Update():
	player.air_physics(player.JUMP_GRAVITY, player.FALL_GRAVITY, player.AIR_FRICTION, player.AIR_ACCEL)


	
func Transition_Check():
	if player.is_on_floor():
		Transitioned.emit("land")
