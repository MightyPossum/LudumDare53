extends Control

var itemList
var selectedItemIndex
var routePanel
var routePlanner
var routePanelDeleteButton
var selectFrom
var selectTo

# Called when the node enters the scene tree for the first time.
func _ready():
	itemList = get_node('RoutePanelRoot/VBoxContainer/ItemList')
	routePanel = get_parent().get_parent().get_node('RoutePanel')
	routePlanner = get_parent().get_parent().get_node('RoutePlanner')
	routePanelDeleteButton = routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('DeleteRoute')
	
	selectFrom = routePlanner.get_node('RoutePlanetPicker').get_node('Control').get_node('HBoxContainer').get_node('VBoxContainer').get_node('SelectFrom')
	selectTo = routePlanner.get_node('RoutePlanetPicker').get_node('Control').get_node('HBoxContainer').get_node('VBoxContainer2').get_node('SelectTo')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_route_pressed():
	## Menu navigation
	routePanel.visible = false
	routePlanner.visible = true
	
func _on_close_pressed():
	## Menu navigation
	routePanel.visible = false

func _populate_list():

	itemList.clear()
	
	for i in Autoscript.PlayerRoutes:
		var route = i
		var locationFromPretty = Autoscript.LocationPrettyName[route.locationFrom]
		var locationToPretty = Autoscript.LocationPrettyName[route.locationTo]
		var itemIndex = itemList.add_item(locationFromPretty + " - " + locationToPretty + " (" + route.vesselName + ")")
		
		itemList.set_item_metadata(itemIndex, route.routeId)
		
	_toggle_add_route_option()


func _on_item_list_item_selected(index):
	selectedItemIndex = index
	
	_toggle_delete_button(false)
	

func _on_delete_route_pressed():
	var routeId = itemList.get_item_metadata(selectedItemIndex)
	for i in Autoscript.PlayerRoutes:
		if i.routeId == routeId:
			Autoscript.PlayerRoutes.erase(i)
			Autoscript.AvailableFleet.append(i.vesselName)
	_populate_list()
	
func _toggle_add_route_option():
	if Autoscript.AvailableFleet.size() == 0:
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('AddRoute').disabled = true
	else:
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('AddRoute').disabled = false
	
	_toggle_delete_button(true)
	
	selectFrom.selected = 0
	selectTo.selected = 0
	
func _toggle_delete_button(boolean):
	routePanelDeleteButton.disabled = boolean
