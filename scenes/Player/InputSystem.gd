extends Node
class_name InputSystem

@export var player: CharacterBody3D

#onready just means var is included in Ready function
@onready var buffer_time = 20 #5/60th of a second for a buffer

@export var input_dict = {
"attack_pressed": 0, 
"special_pressed": 0, 

"left_pressed": 0,
"left_down": 0,

"right_pressed": 0,
"right_down": 0,

"up_pressed": 0,
"up_down": 0,

"down_pressed": 0,
"down_down": 0,

"shield_pressed": 0,
"shield_down": 0,

"jump_pressed": 0,
"jump_down": 0,
"fastfall_pressed": 0}

func _ready():
	pass
	
	
func _physics_process(_delta):
	pass
	
	#if (!in_hitpause): 
	
	
func lower_keys():
	var keys = input_dict.keys()
	for key in keys: 
		if input_dict[key] > 0:
			input_dict[key] -= 1
	
func set_input_dict():
	if Input.is_action_just_pressed("right_%s" % player.id):
		input_dict["right_pressed"] = buffer_time
	if Input.is_action_just_pressed("left_%s" % player.id):
		input_dict["left_pressed"] = buffer_time
	if Input.is_action_just_pressed("down_%s" % player.id):
		input_dict["down_pressed"] = buffer_time
		input_dict["fastfall_pressed"] = buffer_time
	if Input.is_action_just_pressed("up_%s" % player.id):
		input_dict["up_pressed"] = buffer_time
		#ADD TAP JUMP CASE:
	if Input.is_action_just_pressed("jump_%s" % player.id):
		input_dict["jump_pressed"] = buffer_time
	if Input.is_action_just_pressed("attack_%s" % player.id):
		input_dict["attack_pressed"] = buffer_time
	if Input.is_action_just_pressed("shield_%s" % player.id):
		input_dict["shield_pressed"] = buffer_time
	#
	
	#I do this so that they still trigger whenever right_pressed triggers
	if Input.is_action_pressed("right_%s" % player.id):
		input_dict["right_down"] = max(1,input_dict["right_pressed"])
	if Input.is_action_pressed("left_%s" % player.id):
		input_dict["left_down"] = max(1,input_dict["left_pressed"])
	if Input.is_action_pressed("down_%s" % player.id):
		input_dict["down_down"] = max(1,input_dict["down_pressed"])
	if Input.is_action_pressed("up_%s" % player.id):
		input_dict["up_down"] = max(1,input_dict["up_pressed"])
		##ADD TAP JUMP CASE:
	if Input.is_action_pressed("jump_%s" % player.id):
		input_dict["jump_down"] = max(1,input_dict["jump_pressed"])
	if Input.is_action_pressed("shield_%s" % player.id):
		input_dict["shield_down"] = max(1,input_dict["shield_down"])

func clear_buffer(INPUT):
	input_dict[INPUT] = 0
