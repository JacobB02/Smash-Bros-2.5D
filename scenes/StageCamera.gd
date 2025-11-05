extends Camera3D

var focal_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	focal_points = [$"../Player",$"../Player2"]
	pass # Replace with function body.

func move():
	var max_x = focal_points[0].position.x
	var max_y = focal_points[0].position.y
	var min_x = focal_points[0].position.x
	var min_y = focal_points[0].position.y
	var goal_position = Vector2(0,0)
	for f in focal_points:
		max_x = max(f.position.x, max_x)
		min_x = min(f.position.x, min_x)
		max_y = max(f.position.y, max_y)
		min_y = min(f.position.y, min_y)
	goal_position = Vector2((max_x - min_x)/2 + min_x, (max_y - min_y)/2 + min_y)
	
	
	var max_dist =  Vector2(min_x, min_y).distance_to(Vector2(max_x, max_y))
	
	
	var goal_x = goal_position[0]
	var goal_y = goal_position[1] + 2
	var goal_z = max(8, 0.6*max_dist)
	
	if (position == Vector3(0,0,0)):
		position = Vector3(goal_x, goal_y, goal_z)


	
	position = position.lerp(Vector3(goal_x, goal_y, goal_z), 0.1)
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()
