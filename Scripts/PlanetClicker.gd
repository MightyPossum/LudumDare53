extends CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(camera, event, position, normal, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed==true:
		var planetBox = get_tree().get_root().get_node('GameScene').get_node('CanvasLayer').get_node('LocationInfo')._toggle_info_panel(Autoscript.LocationArray[get_parent().name])
