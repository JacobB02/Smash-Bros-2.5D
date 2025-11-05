extends ShapeCast3D
class_name Hitbox

signal Transitioned

var parent #


@onready var percentage = 0
@onready var kb_adj = 1
@onready var base_knockback = 40
@onready var ratio = 1


#these are IMPORTANT. thus exported
@onready var width = 400
@onready var height = 300
@onready var damage = 50
@onready var angle = 90
@onready var base_kb = 100
@onready var kb_scaling = 2
@onready var base_hitpause = 7
@onready var hitpause_scaling = 0.5
@onready var duration = 3
#also: projectile type. And grab later on.
@onready var type = "normal"
#for hit effects??? idfk. later!
@onready var effect = "none"
@onready var angle_flip = 0
#@onready var hitbox = get_node("Hitbox_Shape")

#theres a parent state checker i dont have oopsie

var knockbackVal:float
var lifetime = 0

#list of objects the hitbox CANNOT collide with
var player_list = []

#Sets all of the paremeters for the hitbox, since its called by a function
func set_parameters(w,h,s,d,a,b_kb,kb_s,b_hp,hp_s,dur,typ,p,eff,flip):
	self.position = Vector3(p.x*0.1,p.y*0.1,0) #in relation to player
	player_list.append(parent) #add player to list it CANT hit
	player_list.append(self) #dont want hitbox to collide with self
	width = w
	height = h
	damage = d
	angle = a
	base_kb = b_kb
	kb_scaling = kb_s
	base_hitpause = b_hp
	hitpause_scaling = hp_s
	duration = dur
	type = typ
	#self.position = p
	effect = eff
	angle_flip = flip
	var shape
	shape = BoxShape3D.new()
	shape.size = Vector3(width*0.01, height*0.01, 1)
	#SHAPES BELOW. Not done yet
	#match s:
		#1:
			#shape = RectangleShape2D.new()
			#shape.extents = Vector2(width, height)
		#2:
			#shape = ConvexPolygonShape2D.new()
			#shape.points = PackedVector2Array([
				#Vector2(0, -height), 
				#Vector2(width*0.38, -height*0.92), 
				#Vector2(width*0.71, -height*0.71), 
				#Vector2(width*0.92, -height*0.38), 
				#Vector2(width, 0), 
				#Vector2(width*0.92, height*0.38), 
				#Vector2(width*0.71, height*0.71), 
				#Vector2(width*0.38, height*0.92), 
				#Vector2(0, height), 
				#Vector2(-width*0.38, height*0.92), 
				#Vector2(-width*0.71, height*0.71), 
				#Vector2(-width*0.92, height*0.38), 
				#Vector2(-width, 0), 
				#Vector2(-width*0.92, -height*0.38), 
				#Vector2(-width*0.71, -height*0.71), 
				#Vector2(-width*0.28, -height*0.92), 
				#])
		#3:
			#shape = ConvexPolygonShape2D.new()
			#shape.points = PackedVector2Array([
				#Vector2(0, -height), 
				#Vector2(width*0.4, -height), 
				#Vector2(width*0.8, -height*0.8), 
				#Vector2(width, -height*0.4), 
				#Vector2(width, 0), 
				#Vector2(width, height*0.4), 
				#Vector2(width*0.8, height*0.8), 
				#Vector2(width*0.4, height), 
				#Vector2(0, height), 
				#Vector2(-width*0.4, height), 
				#Vector2(-width*0.8, height*0.8), 
				#Vector2(-width, height*0.4), 
				#Vector2(-width, 0), 
				#Vector2(-width, -height*0.4), 
				#Vector2(-width*0.8, -height*0.8), 
				#Vector2(-width*0.4, -height), 
				#])
	
	set_shape(shape)
	#update_extents()
	set_physics_process(true) #IDK WHY TBH
	
#func update_extents():
	#hitbox.shape.extents = Vector2(width,height)

#Right now does... nothing.
func _ready():
	
	#hitbox.shape = RectangleShape2D.new()
	#set_physics_process(false) #dont want hitbox to do stufff UNTIL that function is called
	print(width)
	print(height)
	
	#hah! this is needed lmao
	#check_collision()
	

func _physics_process(delta): #runs EVERY FRAME
	
	#add extra logic to ensure its NOT a projectile
	if (parent != null): #so that it doesnt run before the parent is found
		if parent.hitpause_time <= 0:
			lifetime += 1
	if lifetime >= duration:
		queue_free()
		
	print("IN HITBOX PHYSICS UPDATE LOOP")
	
	#THIS is the important part
	#checks the collision
	#which is just forcing a shapecast update
	check_collision()
	
#ACTUALLY BEING HIT is handled WITHIN the player
func check_collision():
	force_shapecast_update()
	while is_colliding():
		print("COLLIDING LOOP")
		force_shapecast_update()
		#if shapecast.is_colliding():
			#shapecast.get_parent().get_parent().velocity.x = 500
#
		var results = collision_result
#
		for body in results:
			add_exception(body.collider)
			print(body.collider.parent) #IT THINKS THIS IS NULL? why
			var collider = body.collider

			if body.collider is Hurtbox:
				print("I ADDED TO SOMETHING??")
				print(body.collider)
				#body.collider.parent.velocity.y = 50
				body.collider.parent.colliding_hitboxes.append(self)
				print("I ADDED TO SOMETHING??")
