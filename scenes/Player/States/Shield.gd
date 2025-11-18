extends State
class_name Shield


#hi. I need to add a DASHTURN even if its brief so that I can do RAR


#var SHIELD_FALL_SPEED = 3
#var SHIELD_UP_TIME = 3 #time before the shield activates defensively
#var SHIELD_DASH_WAIT_TIME = 5 #time before you can dash after shield activates
#var SHIELD_DASH_MAX_TIME = 30 #maximum time you can hold shield das
#var SHIELD_DASH_INIT_SPEED = 5
#var SHIELD_DASH_MAX_SPEED = 10
var vsp_changed

func Enter():
	super()
	
	vsp_changed = false

	if (player.velocity.y < 0):
		vsp_changed = true


		#if (player.in_first_jump <= 0 and player.velocity.y > 0):
			#player.velocity.y *= 0.25
		#elif (player.in_first_jump > 0):
			#player.velocity = 
		#player.velocity.x = 0
		#player.velocity.y = 0
	
	


func Physics_Update():
	
	if (!player.is_on_floor()):
		if (player.in_first_jump <= 0 and player.velocity.y > 0 and !vsp_changed):
			player.velocity.y *= 0.25
			vsp_changed = true
	
	#print("velocity:", player.velocity.y)
	
	print(vsp_changed)
	
	#print(input_dict["shield_down"])
	
	#print(player.in_first_jump)
	if !vsp_changed:
		player.air_physics()
		#pass
	else:
		player.air_physics(player.FALL_GRAVITY/16, player.AIR_FRICTION*2, 0, player.FALLSPEED)

	
	#startup
	if (player.window == 0):
		player.b_reverse()
		
		if !player.is_on_floor():
			pass
			#player.air_physics(0.02, 10, 0, 20)
		else:
			player.ground_friction(2*player.GROUND_FRICTION)

		if (player.frame == player.SHIELD_UP_TIME):
			player.window += 1
			player.frame = 0
	#charge
	elif (player.window == 1):
		
		#player.velocity.x = 0
		#player.velocity.y = 0
		if ((player.frame >= player.SHIELD_DASH_WAIT_TIME and !input_dict["shield_down"]) or
		(player.frame >= player.SHIELD_DASH_MAX_TIME)):
			if (input_dict["right_down"]):
				
				player.velocity.x = player.SHIELD_DASH_INIT_SPEED + player.frame*(player.SHIELD_DASH_MAX_SPEED - player.SHIELD_DASH_INIT_SPEED)/player.SHIELD_DASH_MAX_TIME
			if (input_dict["up_down"]):
				player.velocity.y = 10
			
			if (input_dict["left_down"]):
				
				player.velocity.x = -(player.SHIELD_DASH_INIT_SPEED + player.frame*(player.SHIELD_DASH_MAX_SPEED - player.SHIELD_DASH_INIT_SPEED)/player.SHIELD_DASH_MAX_TIME)
			player.window += 1
			player.frame = 0

	
	
func Transition_Check():
	if (player.frame >= 80):
		Transitioned.emit("jump")
		inputs.clear_buffer("shield_pressed") 
		
	if (player.window == 2):
		Transitioned.emit("jump")
		player.velocity.y *= 4
		inputs.clear_buffer("shield_pressed") 
