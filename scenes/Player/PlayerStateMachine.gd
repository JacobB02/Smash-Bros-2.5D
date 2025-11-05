extends Node

@export var player: CharacterBody3D
#what we want the initial state to be
@export var initial_state : State

@export var prev_state : State
@export var current_state : State
var states : Dictionary = {}



#loads all of the states into the appropriate names
func _ready():
	
	
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			#makes every child have the same player var
			child.player = player
			child.state_machine = self
			child.input_dict = get_node("../InputSystem").input_dict
			child.inputs = get_node("../InputSystem")
			
	current_state = initial_state
	initial_state.Enter()


#Runs Process within the state if needed
func _process(_delta):
	if current_state:
		current_state.Update()

#runs Physics Process within state if needed
func _physics_process(_delta):
	
	
	#if (current_state.name == "DoubleJump" and player.frame == 7 and player.hitpause_time <= 0):
		#var hbox = player.create_hitbox(500,700,1,5,80,
		#5,1.0,
		#50,0.5,3,"normal",Vector2(20,-5),0,6)
		#YEA FOR SOME REASON I NEED TO CALL THIS IMMEDIATELY WAHOO
		#yea. may need to reconsider how i call hitboxes
		#BUT for now: this works!
		
		#hbox._physics_process(_delta)
		#confused if i can do this in READY too
		

	#Hello future me
	#might be good to swap these 2 around?
	#but rn having an Exit call helps a lot
	
	if current_state:
		current_state.Transition_Check()
		
	if current_state:
		current_state.Physics_Update()
		
	#print(current_state.name)


#in the tutorial version they check if state == current state. 
#i do not
func on_child_transition(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return

	if current_state:
		current_state.Exit()

	#extra prev_state
	prev_state = current_state
	current_state = new_state
	new_state.Enter()
	
