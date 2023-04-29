extends PathFollow3D

var speed
var init_speed = 0
var current_position
var direction
var stop_timer
var current_location = 'p1'
var destination 

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = init_speed
	current_position = 0.1
	direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed > 0:
		if current_position >= 0.99:
			current_position = 0.98
			speed = 0
			direction = -direction
		elif current_position <= 0.01:
			current_position = 0.02
			speed = 0
			direction = -direction


		current_position += delta * speed * direction
	
		set_progress_ratio(current_position)
		
