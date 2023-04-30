extends Control

var selectFrom
var selectTo
var applyButton
var routePlanner
var routePanel
var locationFrom
var locationTo
var routePanelItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	selectFrom = get_node("Control/HBoxContainer/VBoxContainer/SelectFrom")
	selectTo = get_node("Control/HBoxContainer/VBoxContainer2/SelectTo")
	applyButton = get_node("Control/HBoxContainer/VBoxContainer2/Apply")
	routePlanner = get_parent().get_parent().get_node('RoutePlanner')
	routePanel = get_parent().get_parent().get_node('RoutePanel')
	routePanelItemList = routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('VBoxContainer').get_node('ItemList')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (selectFrom.selected == 0 or selectTo.selected == 0) or (selectFrom.selected == selectTo.selected):
		applyButton.disabled = true
	else:
		applyButton.disabled = false

func _on_cancel_pressed():
	## Menu Navigation
	routePlanner.visible = false
	routePanel.visible = true
	routePanelItemList.deselect_all()
	routePanel.get_node('RoutePanel')._toggle_delete_button(true)

func _on_apply_pressed():
	## Menu navigation
	routePlanner.visible = false
	routePanel.visible = true
	routePanelItemList.deselect_all()
	var locationToNodeName
	var locationFromNodeName
	
	## Logic
	for i in Autoscript.LocationArray:
		
		if selectFrom.get_selected_id() == Autoscript.LocationArray[i].locationId:
			locationFromNodeName = Autoscript.LocationArray[i].locationNodeName
		elif selectTo.get_selected_id() == Autoscript.LocationArray[i].locationId:
			locationToNodeName = Autoscript.LocationArray[i].locationNodeName
		
	var locationFrom = locationFromNodeName
	var locationTo = locationToNodeName
	var route : Route = Route.new()
	get_tree().get_root().get_node('GameScene').get_node('Routes').add_child(route)
	
	route.locationFrom = locationFrom
	route.locationTo = locationTo
	route.vesselName = Autoscript.AvailableFleet.pop_front()
	route.routeId = Autoscript.routeIDTracker
	Autoscript.routeIDTracker += 1
	
	Autoscript.PlayerRoutes.append(route)
	
	routePanel.get_node('RoutePanel')._populate_list()
	route._create_route()
	
	
