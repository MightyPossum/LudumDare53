extends Control

@onready var item_list = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Autoscript.VesselList:
		item_list.add_item(i.vessel_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
