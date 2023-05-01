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
	itemList = get_node('RoutePanelRoot/ItemList')
	routePanel = get_parent().get_parent().get_node('RoutePanel')
	routePlanner = get_parent().get_parent().get_node('RoutePlanner')
	routePanelDeleteButton = routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('DeleteRoute')
	
	selectFrom = routePlanner.get_node('RoutePlanetPicker').get_node('Control').get_node('HBoxContainer').get_node('VBoxContainer').get_node('SelectFrom')
	selectTo = routePlanner.get_node('RoutePlanetPicker').get_node('Control').get_node('HBoxContainer').get_node('VBoxContainer2').get_node('SelectTo')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		visible = false


func _on_add_route_pressed():
	## Menu navigation
	routePanel.visible = false
	routePlanner.visible = true
	var route_text = routePlanner.get_node("RoutePlanetPicker").get_node('Control').get_node('RouteText')
	route_text.clear()
	route_text.append_text('[b]Route From[/b]\nN/A\n[b]Route To[/b]\nN/A\n[b]Assigned Vessel[/b]\nN/A\n[b]inital Cost[/b]\nN/A\n[b]Repeating Cost[/b]\nN/A')
	get_tree().get_root().get_node('GameScene')._generateSelectLists()
	
func _on_close_pressed():
	## Menu navigation
	routePanel.visible = false

func _populate_list():

	itemList.clear()
	
	for i in Autoscript.PlayerRoutes:
		var route = i
		var locationFromPretty = Autoscript.LocationPrettyName[route.locationFrom]
		var locationToPretty = Autoscript.LocationPrettyName[route.locationTo]
		var item_name
		if route.repeating:
			item_name = locationFromPretty + " <-> " + locationToPretty + " (" + Autoscript.VesselList[route.vessel_id].vessel_name + ")"
		else:
			item_name = locationFromPretty + " -> " + locationToPretty + " (" + Autoscript.VesselList[route.vessel_id].vessel_name + ")"
		
		var itemIndex = itemList.add_item(item_name)
		
		itemList.set_item_metadata(itemIndex, route.routeId)
		
	_toggle_add_route_option()


func _on_item_list_item_selected(index):
	selectedItemIndex = index
	
	_toggle_delete_button(false)
	

func _on_delete_route_pressed():
	var routeId = itemList.get_item_metadata(selectedItemIndex)
	for i in Autoscript.PlayerRoutes:
		if i.routeId == routeId:
			i.repeating = false
	_populate_list()
	
func _toggle_add_route_option():
	if Autoscript.AvailableFleet.size() == 0:
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('AddRoute').disabled = true
	else:
		routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('AddRoute').disabled = false
	
	_toggle_delete_button(true)
	
func _toggle_delete_button(boolean):
	routePanelDeleteButton.disabled = boolean
