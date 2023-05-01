@tool
extends Area3D

@export var asteroid_model : PackedScene
@onready var asteroid_label = $AsteroidLabel
@export var demand : int = 0
@export var demand_rate = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if asteroid_model != null:
		get_node('MVPAsteroid').queue_free()
		add_child(asteroid_model.instantiate())
	else:
		print('Fix Asteroid ' + str(self.name))
		
	asteroid_label.text = get_node('LocationName').get_child(0).name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
