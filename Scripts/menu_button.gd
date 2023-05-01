extends MenuButton

@onready var routePanel = get_parent().get_parent().get_parent().get_node('RoutePanel')
@onready var vesselPanel = get_parent().get_parent().get_parent().get_node('VesselList')


# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().connect("id_pressed", _on_id_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed():
	pass

func _on_id_pressed(index):
	if index == 0:
		
		routePanel.visible = true
		
		routePanel.get_node("RoutePanel")._toggle_add_route_option()
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('DeleteRoute').disabled = true
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('VBoxContainer').get_node('ItemList').deselect_all()
		routePanel.get_node('RoutePanel')._populate_list()
	elif index == 1:
		
		vesselPanel.visible = true
