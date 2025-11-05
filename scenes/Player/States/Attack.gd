extends State
class_name attack

func Enter():
	super()
	
	inputs.clear_buffer("attack_pressed")
	player.ground_friction(player.GROUND_FRICTION)
	
	if (!player.is_on_floor()): #AIR ATTACKS
		player.attack_name = "fair"
	
	elif (player.input_dict["up_pressed"] or player.input_dict["up_down"]):
		player.attack_name = "utilt"
	elif (player.input_dict["down_pressed"] or player.input_dict["down_down"]):
		player.attack_name = "dtilt"
	elif ((player.dir == 1 and (input_dict["right_pressed"] or input_dict["right_down"]))
	or (player.dir == -1 and (input_dict["left_pressed"] or input_dict["left_down"]))):
		player.attack_name = "ftilt"
	elif (input_dict["right_pressed"] or input_dict["right_down"] 
	   or input_dict["left_pressed"] or input_dict["left_down"]):
		player.attack_name = "ftilt"
		player.dir *= -1
	elif (input_dict["left_pressed"] or input_dict["left_down"]):
		player.attack_name = "uspec"
	else:
		player.attack_name = "Ftilt"
		
	player.attack_name = "Ftilt"
	
	#YOOOO HYPE
	player.attack_file = player.get_node("Attacks/" + player.attack_name)
	#print(str(attack_file.data["category"]))
	
	print(player.attack_file)
	
	#sprite.play(str(parent.attack_file.data["sprite"]))
	#parent.window = 0
	#parent.window_timer = 0
	#
	player.landing_lag_time = player.attack_file.data["landing_lag"]
	
	
func Physics_Update():
	
	if (!player.hitpause_time):
		if player.is_on_floor():
			player.ground_friction(player.GROUND_FRICTION)
		else:
			player.air_physics(player.JUMP_GRAVITY, 
								player.FALL_GRAVITY, 
								player.AIR_FRICTION, 
								player.AIR_ACCEL)
		
		player.window_timer += 1
		player.window_data = player.attack_file["window_"+str(player.window)]
		
		#goes up to the next window or, if end of attack, ends attack.
		if (player.window < player.attack_file.data["num_windows"]
			and player.window_timer >= player.window_data.length):
			player.window += 1
			player.window_timer = 0
		if (player.window == player.attack_file.data["num_windows"]):
			#attack_end()
			pass
			
		if (player.window < player.attack_file.data["num_windows"]):
			player.window_data = player.attack_file["window_"+str(player.window)]
			
		#spawns the hitbox
		#NEED TO FIX omg

		for hitbox in player.attack_file["hitboxes"]:
			if ((hitbox.window == player.window) and 
			   (hitbox.window_frame == player.window_timer)):
					player.create_hitbox(
								hitbox["width"],
								hitbox["height"],
								hitbox["shape"],
								hitbox["damage"],
								hitbox["angle"],
								hitbox["base_kb"],
								hitbox["kb_scaling"],
								hitbox["base_hitpause"],
								hitbox["hitpause_scaling"],
								hitbox["duration"],
								hitbox["type"],
								hitbox["position"],
								hitbox["effect"],
								hitbox["angle_flip"]
								)
								
					
				
				
			
		
		
	#sprite.set_frame(parent.window_data.anim_frame_start + parent.window_timer*parent.window_data.anim_frames/parent.window_data.length)
		
	
	#if (parent.frame == 5):
		#parent.create_hitbox(50,50,5,40,
		#5,1.0,
		#5,0.5,3,"normal",Vector2(80,-20),0,0)
		
	


	
func Transition_Check():
	#i had to do this so the hitbox spawns
	#ONLY if this move is NOT transitioning
	if (!player.hitpause_time):
		if (player.attack_file.data["category"] == 1 and player.is_on_floor()):
			Transitioned.emit("landing_lag")
		elif (player.window == player.attack_file.data["num_windows"]):
			#GROUNDED
			if player.is_on_floor():
				if (player.input_dict["right_pressed"] or player.input_dict["left_pressed"]):
					Transitioned.emit("dashstart")
				elif (player.input_dict["jump_pressed"] and player.num_djumps > 0):
					Transitioned.emit("jumpsquat")
				elif (player.input_dict["attack_pressed"]):
					Transitioned.emit("attack")
				else:
					Transitioned.emit("idle")
			#MIDAIR
			else:
				if (player.input_dict["jump_pressed"] and player.num_djumps > 0):
					Transitioned.emit("DoubleJump")
				elif (player.input_dict["attack_pressed"]):
					Transitioned.emit("attack")
				else:
					Transitioned.emit("idle_air")
				
