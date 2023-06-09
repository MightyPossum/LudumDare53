@tool
extends Area3D

@export var planet_model : PackedScene
@onready var planet_label = $PlanetLabel
@export var demand : int = 0
@export var demand_rate = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if planet_model != null:
		get_node('MVPPlanet').queue_free()
		add_child(planet_model.instantiate())
	else:
		print('Fix Planet ' + str(self.name))
	
	planet_label.text = get_node('LocationName').get_child(0).name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_demand():
	return demand
