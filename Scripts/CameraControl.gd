extends Camera3D

@export var speed = 250
@export var zoom_speed = 2000
@export var zoom_margin = 0.1
@export var zoom_min = 0.5
@export var zoom_max = 3.0

var zooming

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)

func _move(delta):
	var velocity = Vector3()
	
	if Input.is_action_just_released("WheelUp") or Input.is_action_just_released("WheelDown"):
		if Input.is_action_just_released("WheelUp"):
			velocity -= transform.basis.z
		if Input.is_action_just_released("WheelDown"):
			velocity += transform.basis.z
			
			
		velocity = velocity.normalized()
		
		position += velocity * delta * zoom_speed
		
	if Input.is_action_pressed("camera_right") or Input.is_action_pressed("camera_left") or Input.is_action_pressed("camera_up") or Input.is_action_pressed("camera_down"):
		if Input.is_action_pressed("camera_right"):
			velocity += transform.basis.x
		if Input.is_action_pressed("camera_left"):
			velocity -= transform.basis.x
		if Input.is_action_pressed("camera_up"):
			velocity += transform.basis.y
		if Input.is_action_pressed("camera_down"):
			velocity -= transform.basis.y
		
		velocity = velocity.normalized()
		
		position += velocity * delta * speed
