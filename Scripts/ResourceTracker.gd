extends Control

@onready var cash_label = $Cash
@onready var material_label = $Material

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cash_label.text = str(Autoscript.Cash)
	material_label.text = str(Autoscript.Materials)
