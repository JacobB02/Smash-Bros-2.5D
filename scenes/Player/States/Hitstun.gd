extends State
class_name Hitstun


func Enter():
	super()
	print("hitstun time: ", player.hitstun_remaining)
	
	#orig_velocity = 
	pass
	
func Physics_Update():
	
	player.knockback_physics()
	
	
	
	
	#print("I AM IN HITSTUN")

	
func Transition_Check():
	if player.hitstun_remaining == 0:
		Transitioned.emit("jump")
	pass
