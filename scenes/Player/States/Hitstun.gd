extends State
class_name Hitstun

func Enter():
	super()
	print("hitstun time: ", player.hitstun_remaining)
	#orig_velocity = 
	pass
	
func Physics_Update():
	#player.air_physics(player.JUMP_GRAVITY, player.FALL_GRAVITY, player.AIR_FRICTION, player.AIR_ACCEL)
	pass
	
	
	
	#print("I AM IN HITSTUN")

	
func Transition_Check():
	if player.hitstun_remaining == 0:
		Transitioned.emit("jump")
	pass
