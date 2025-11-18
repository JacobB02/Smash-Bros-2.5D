extends CharacterBody3D
class_name Player


@onready var hitbox = preload("res://scenes/components/hitbox/hitbox.tscn")
@onready var hurtbox = preload("res://scenes/components/hurtbox/hurtbox.tscn")

@export var id = 1
@onready var dir = 1
@onready var frame = 0
@onready var b_reversed = false
@onready var window = 0
@onready var window_timer = 0



@onready var landing_lag_time = 0
@onready var window_data
@onready var num_djumps = 0



var hitpause_time = 10
var hitstun_remaining = 0
var hitstun_total = 0


var old_velocity = Vector2(0,0)

var colliding_hitboxes = []
var curr_launch_angle = 0
var curr_launch_speed = 0
var percentage = 0
#you ADD ON to the curr launch angle and speed i GUESS
#average it out BITCH
#wait no. get relative power of both and THEN average THAT out
#this is gonna be hella math 

var can_fastfall = true
#var in_hitpause = false
var has_midair_shield = false



var GROUND_FRICTION = 0.3

var JUMP_START_LENGTH = 5


#ones needed for the jumping math. init height, full height, and gravity
var jump_h = 200
var jump_h0 = 0.6*jump_h
var shorthop_h = 120
var djump_h = 200
var FALL_GRAVITY = 0.7

#code below assumes FIVE frames to reach peak of jump_h0
#for 4: 4 and 6
#for 5: 5 and 10
#5 is a 1 frame difference its not worth it.
var jump_vf = sqrt(2*FALL_GRAVITY*(jump_h-jump_h0))
var JUMP_START_GRAVITY = (jump_h0 - 5*jump_vf)/10
var JUMP_START_VELOCITY = jump_vf + 5*JUMP_START_GRAVITY

var SHORTHOP_START_VELOCITY = sqrt(2*FALL_GRAVITY*(shorthop_h))
var djump_vf = sqrt(2*FALL_GRAVITY*(djump_h))

var DJUMPSPEED = 2
var SHORTHOPSPEED = 20
var MAXAIRSPEED = 5
var AIR_ACCEL = 0.15
var AIR_FRICTION = 0.1
var LAND_TIME = 4



var FALLSPEED = 15
var FASTFALLSPEED = 20

var JUMP_HSP_MAX = 6
var JUMP_CHANGE = 5#max HSP if flipping directions suddenly. yeaaaa. bro.
var DJUMP_HSP_MAX = 5
var DJUMP_CHANGE = 6

var DASHSPEED = 10
var DASH_START_LENGTH = 12
var RUNSPEED = 9




var SHIELD_FALL_SPEED = 3
var SHIELD_UP_TIME = 3 #time before the shield activates defensively
var SHIELD_DASH_WAIT_TIME = 5 #time before you can dash after shield activates
var SHIELD_DASH_MAX_TIME = 30 #maximum time you can hold shield das
var SHIELD_DASH_INIT_SPEED = 7
var SHIELD_DASH_MAX_SPEED = 15



var in_first_jump = 0

@onready var attack_name
@onready var attack_file

@onready var PlatDetector = get_node("PlatDetector")

@onready var input_dict = get_node("InputSystem").input_dict
@onready var inputs = get_node("InputSystem")

@onready var state = get_node("StateMachine").current_state
@onready var prev_state = get_node("StateMachine").prev_state

var platform_collision_list = []




func _ready():
	#this is needed so that the hurtbox knows who to reference
	for child in get_children():
		if child is Hurtbox:
			child.parent = self


func _physics_process(_delta):
	#
	##CREATING A HITBOX (change later to be. better)
	#var hurtbox_instance = hurtbox.instantiate()
	#hurtbox_instance.parent = self
	#self.add_child(hurtbox_instance)
	#
	inputs.set_input_dict()
	
	if dir == 1:
		$MeshInstance3D.rotation = Vector3(0,0,0)
	else:
		$MeshInstance3D.rotation = Vector3(0,PI,0)
	
	#HELLL YEA
	#the hitbox spawning needs to be done BEFORE this
	
	#if (velocity.y > 0 || input_dict["down_down"]):
		#set_collision_mask_value(3, false)
	#else:
		#set_collision_mask_value(3, true)
		#
	#set_collision_mask_value(2, true)
	if is_on_floor() and input_dict["down_hard_pressed"]:
		set_collision_mask_value(3, false) 
		print("DOWN HARD")
	elif !is_on_floor() and input_dict["down_down"]:
		set_collision_mask_value(3, false) 
		print("DOWN DOWN")
	else:
		set_collision_mask_value(3, true) 
	
	
	
	
	if (hitpause_time > 0):
		hitpause_time -= 1
		velocity.x = 0
		velocity.y = 0
		if hitpause_time <= 0:
			velocity.x = old_velocity[0]
			velocity.y = old_velocity[1]
			#SET EXIT VSP AND HSP
	if (hitpause_time <= 0):
		frame += 1
		if (hitstun_remaining > 0):
			hitstun_remaining -= 1
		
	
	#print(state)
	#position.x = snapped(position.x, 0.01)
	#position.y = snapped(position.y, 0.01)
	move_and_slide()
	
	
	#This is the area that lets you land on platforms
	PlatDetector.force_shapecast_update()
	for collider in get_collision_exceptions():
		remove_collision_exception_with(collider)

	if PlatDetector.is_colliding():
		PlatDetector.force_shapecast_update()
		PlatDetector.force_shapecast_update()
		PlatDetector.force_shapecast_update()
		PlatDetector.force_shapecast_update()
		PlatDetector.force_shapecast_update()
		for body in PlatDetector.collision_result:
			#PlatDetector.add_exception(body.collider)
			#print(body)
			add_collision_exception_with(body.collider)
	#move_and_slide()
	#frame += 1
	
	#print("state: ", snapped(velocity.y, 0.01))
	#print("position: ", snapped(position.y, 0.01))
	#print("jsg", JUMP_START_GRAVITY)
	#print(frame)
	
	#if (!in_hitpause): 
	inputs.lower_keys.call_deferred()
	
	check_colliding_hitboxes.call_deferred()


func ground_friction(FRICTION):
	if velocity.x > 0:
		velocity.x = clamp(velocity.x - FRICTION, 0, velocity.x)
	if velocity.x < 0:
		velocity.x = clamp(velocity.x + FRICTION, velocity.x, 0)


func air_physics(fall_grav = FALL_GRAVITY, air_fric = AIR_FRICTION, air_accel = AIR_ACCEL, fall_speed = FALLSPEED, jump_start_grav = JUMP_START_GRAVITY):
	
	#vertical physics
	#if velocity.y > FALLSPEED:
	
	if (in_first_jump > 0): 
		velocity.y = clamp(velocity.y-jump_start_grav, -fall_speed, 500)
		in_first_jump -= 1
	else: 
		velocity.y = clamp(velocity.y-fall_grav, -fall_speed, 500)

	
	
	#if (can_fastfall and velocity.y > 0):
		#if velocity.y and input_dict["fastfall_pressed"]:
			#clear_buffer("fastfall_pressed")
			#velocity.y = FASTFALLSPEED
		
	#FIX IN THE FUTURE??
	
	
	#issue is NOT order, its the code itself
	if (air_accel != 0 and input_dict["right_down"] and !(input_dict["left_down"])):
		if (velocity.x < MAXAIRSPEED):
			velocity.x = velocity.x+air_accel
			if (velocity.x >= MAXAIRSPEED):
				velocity.x = MAXAIRSPEED
	elif (air_accel != 0 and !(input_dict["right_down"]) and input_dict["left_down"]):
		if (velocity.x > -MAXAIRSPEED):
			velocity.x = velocity.x-air_accel
			if (velocity.x <= -MAXAIRSPEED):
				velocity.x = -MAXAIRSPEED
	else:
		#after ELSE or not??
		if velocity.x > 0 :
			velocity.x = clamp(velocity.x - air_fric, 0, velocity.x)
		if velocity.x < 0:
			velocity.x = clamp(velocity.x + air_fric, velocity.x, 0)
		
		
func frame_reset():
	frame = 0
	window = 0
	b_reversed = false
		
		
func create_hitbox(width, height, shape, damage, angle, base_kb, 
					kb_scaling, base_hp, hp_scaling, duration, 
					type, points, effect, angle_flipper):
	var hitbox_instance = hitbox.instantiate()
	hitbox_instance.parent = self
	self.add_child(hitbox_instance)
	#ignore self to hit (this is if its a physical hitbox. idfk)
	hitbox_instance.add_exception($Hurtbox)
	#rotates the points
	if (dir == 1):
		hitbox_instance.set_parameters(width, height, shape, damage, angle, base_kb, 
										kb_scaling, base_hp, hp_scaling, duration, 
										type, points, effect, angle_flipper)
	else:
		var flip_x_points = Vector2(-points.x, points.y)
		hitbox_instance.set_parameters(width, height, shape, damage, -angle+180, base_kb, 
										kb_scaling, base_hp, hp_scaling, duration, type, 
										flip_x_points, effect, angle_flipper)
	#hitbox_instance.testing_this()
	#hitbox_instance.check_entered()
	
		
	#hitbox_instance.check_for_results()
	#NEEDED please seriously
	#this is so that it checks RIGHT at creation
	
	
	hitbox_instance.check_collision()
	return hitbox_instance
	
	
#CHECKS EVERY SINGLE COLLIDING HITBOX
func check_colliding_hitboxes():
	
	


	var i = 0
	var hitboxes_hit_by = []
	#if any hitbox is colliding
	if colliding_hitboxes != []:
		#If only one hitbox, thats it! you got hit baby
		if colliding_hitboxes.size() == 1:
			hitboxes_hit_by.append(colliding_hitboxes.pop_back())
			print(hitboxes_hit_by[0])
		#if multiple hitboxes...sigh
		else:
			#as long as there are more hitboxes to check
			while colliding_hitboxes != []:
				#add the last hitbox to the end of the list and pop it!
				hitboxes_hit_by.append(colliding_hitboxes.pop_back())
				#go through ALL OF the REMAINING hitboxes, compared to the first one popped
				#this way we make sure its the highest priority hitbox FOR THAT PARENT OBJECT
				#this first i hitbox is the highest priority one OF THAT PARENT
				#removes all of the other parents
				for j in colliding_hitboxes.size():
					#if any have the same parent as the current i
					if colliding_hitboxes[j].parent == hitboxes_hit_by[i].parent:
						#check if their priority is GREATER. if so, add. if not, dont
						if colliding_hitboxes[j].priority > hitboxes_hit_by[i].priority:
							hitboxes_hit_by[i] = colliding_hitboxes[j]
						elif colliding_hitboxes[j].priority == hitboxes_hit_by[i].priority:
							print("TWO HITBOXES WITH SAME PRIORITY AT SAME TIME")
							print("this is ILLEGAL and BAD.")
				#filters out all of the other hitboxes WITH THAT PARENT
				colliding_hitboxes.filter(func(hitbox): 
					return hitbox.parent != hitboxes_hit_by[i].parent)
				i += 1
	
	#so
	#i add all of the vectors and get their average for ANGLE
	#for knockback: uhm.
	#i dont WANT it to be additive. Unless i do???
	#y know what. fuck it
	#get the average vector of each hitbox
	var new_launch_vector = Vector2(0,0)
	var new_launch_speed = 0
	
	
	
	for hitbox in hitboxes_hit_by:
		#spawn in the sounds and hitfx
		#ADD THEIR DAMAGE TO YOU
		percentage += hitbox.damage
		#hitpause
		#MAKE THE PARENT HAVE HITPAUSE
		hitbox.parent.hitpause_time = hitbox.base_hitpause #change to be MAX of multiple things
		hitbox.parent.old_velocity[0] = hitbox.parent.velocity.x
		hitbox.parent.old_velocity[1] = hitbox.parent.velocity.y
		print(hitbox.angle)
		#so basically. Fastest speed, angle averaged out based on KB
		new_launch_speed = max(new_launch_speed, knockback(percentage,hitbox))
		new_launch_vector += Vector2(new_launch_speed*cos(deg_to_rad(hitbox.angle)), 
									new_launch_speed*sin(deg_to_rad(hitbox.angle)))
		print(new_launch_vector)
		curr_launch_angle = rad_to_deg(new_launch_vector.angle())
		#hitpause time for the PERSON BEING HIT is the max base hitpause 
		#of all of the attacks hitting them
		hitpause_time = max(hitpause_time, hitbox.base_hitpause)
		hitstun_total = max(hitstun_total, ceil(new_launch_speed))
		hitstun_remaining = hitstun_total
		
	

	if hitboxes_hit_by != []:
		#hitpause_time = max()
		print(curr_launch_angle)
		velocity.x = new_launch_speed*cos(deg_to_rad(curr_launch_angle))
		old_velocity[0] = velocity.x
		print("x" + str(velocity.x))
		velocity.y = new_launch_speed*sin(deg_to_rad(curr_launch_angle))
		old_velocity[1] = velocity.y
		print("y" + str(velocity.y))
		#removes any hitboxes if the person has been hit 
		#effectively making a 0 frame hitbox
		#yay!
		for child in get_children():
			if child is Hitbox:
				child.queue_free()
				
	#FOR ALL OF THE HITBOXES
	if hitboxes_hit_by != []:
		print("_____________hello")
		get_node("StateMachine").on_child_transition("hitstun")
		

func knockback(p,hitbox):
	var damage = hitbox.damage
	var kb_adj = hitbox.kb_adj
	var kb_scaling = hitbox.kb_scaling
	var base_kb = hitbox.base_kb

	return float(base_kb+(p+damage)*kb_scaling*0.5*kb_adj)*1.2


func b_reverse():
	if (input_dict["left_pressed"] and dir == 1 and !b_reversed):
		dir = -1
		b_reversed = true
	elif (input_dict["right_pressed"] and dir == -1 and !b_reversed):
		dir = 1
		b_reversed = true
