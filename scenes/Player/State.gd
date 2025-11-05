extends Node
class_name State

#automatically set by StateMachine class
var player
var state_machine
var inputs
var input_dict
var current_state
var prev_state

#how you transition between states
signal Transitioned

func Enter():
	player.frame_reset()
	pass
	
func Exit():
	pass
	
func Update():
	pass
	
func Physics_Update():
	if player.is_on_floor():
		print("on floor!")
