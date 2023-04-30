extends Area3D

@export var PlanetModel : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('MVPPlanet').queue_free()
	if PlanetModel != null:
		add_child(PlanetModel.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
