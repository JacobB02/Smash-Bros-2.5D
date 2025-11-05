extends Node

var data = {
"category": 0, 
#"sprite": "Dtilt", 
#"air_sprite": "Dtilt",
"num_windows": 3,
"num_hitboxes": 1,
"landing_lag": 0}

var window_0 = {
"type": 0, #dictates looping behavior etc idfk
"length": 6, 
#"anim_frames": 2,
#"anim_frame_start": 0,
"has_sfx": false,
"sfx": "name",
"sfx_frame": 0,
"whifflag": false,
"has_custom_friction": false,
"custom_friction": 0,
"has_custom_gravity": false,
"custom_gravity": 0}

var window_1 = {
"type": 0, #dictates looping behavior etc idfk
"length": 3, 
#"anim_frames": 1,
#"anim_frame_start": 2,
"has_sfx": false,
"sfx": "name",
"sfx_frame": 0,
"whifflag": false,
"has_custom_friction": false,
"custom_friction": 0,
"has_custom_gravity": false,
"custom_gravity": 0}

var window_2 = {
"type": 0, #dictates looping behavior etc idfk
"length": 10, 
#"anim_frames": 3,
#"anim_frame_start": 3,
"has_sfx": false,
"sfx": "name",
"sfx_frame": 0,
"whifflag": false,
"has_custom_friction": false,
"custom_friction": 0,
"has_custom_gravity": false,
"custom_gravity": 0}

var windows = {
"window_0": window_0,
"window_1": window_1,
"window_2": window_2,
}

var hitbox_1 = {
"window" = 1,
"window_frame" = 0,
"width" = 35,
"height" = 10,
"shape" = 3,
"damage" = 5,
"angle" = 90,
"base_kb" = 5,
"kb_scaling" = 0.3,
"base_hitpause" = 7,
"hitpause_scaling" = 0.7,
"duration" = 3,
"type" = "normal",
"position" = Vector2(30,2),
"effect" = 0,
"angle_flip" = 6
}

var hitboxes = [
hitbox_1
]
