extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_route_pressed():
	## Menu navigation
	get_parent().get_parent().get_node('RoutePanel').visible = false
	get_parent().get_parent().get_node('RoutePlanner').visible = true
	
func _on_close_pressed():
	## Menu navigation
	get_parent().get_parent().get_node('RoutePanel').visible = false
