extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().connect("id_pressed", _on_id_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	print('asdasda')

func _on_id_pressed(loser):
	## Menu navigation
	get_parent().get_parent().get_parent().get_node('RoutePanel').visible = true
