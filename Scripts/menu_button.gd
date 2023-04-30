extends MenuButton

var routePanel

# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().connect("id_pressed", _on_id_pressed)
	routePanel = get_parent().get_parent().get_parent().get_node('RoutePanel')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed():
	pass

func _on_id_pressed(index):
	## Menu navigation
	routePanel.visible = true
	
	## Logic
	routePanel.get_node("RoutePanel")._toggle_add_route_option()
	routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('DeleteRoute').disabled = true
	routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('VBoxContainer').get_node('ItemList').deselect_all()
