extends State
class_name DoubleJump

func Enter():
	super()
	player.velocity.y = player.JUMP_START_VELOCITY
	player.in_first_jump = 5
	
	if (player.input_dict["right_down"] > player.input_dict["left_down"]):
		player.velocity.x = max(player.DJUMP_CHANGE, player.velocity.x)
		#player.velocity.x = clamp(player.velocity.x+player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
	elif (player.input_dict["right_down"] < player.input_dict["left_down"]):
		player.velocity.x = min(-player.DJUMP_CHANGE, player.velocity.x)
		#player.velocity.x = clamp(player.velocity.x-player.JUMP_CHANGE, -player.JUMP_HSP_MAX, player.JUMP_HSP_MAX)
	
		
	pass
	
func Physics_Update():
	player.air_physics(player.FALL_GRAVITY, player.AIR_FRICTION, player.AIR_ACCEL)

	if player.frame == 7 and player.hitpause_time <= 0:
		var hbox = player.create_hitbox(500,700,1,5,80,
			5,1.0,
			50,0.5,3,"normal",Vector2(20,-5),0,6)

	
func Transition_Check():
	if player.is_on_floor():
		Transitioned.emit("land")
