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
	applyButton = get_node("Control/Apply")
	routePlanner = get_parent().get_parent().get_node('RoutePlanner')
	routePanel = get_parent().get_parent().get_node('RoutePanel')
	routePanelItemList = routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('VBoxContainer').get_node('ItemList')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (selectFrom.selected == 0 or selectTo.selected == 0) or (selectFrom.get_selected_id() == selectTo.get_selected_id()):
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
	_route_creation(false)
	
func _route_creation(repetetive):
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
		
	_create_route(locationFromNodeName, locationToNodeName, repetetive)

func _create_route(location_from, location_to, repetetive):
	var route : Route = Route.new()
	get_tree().get_root().get_node('GameScene').get_node('Routes').add_child(route)
	
	route.locationFrom = location_from
	route.locationTo = location_to
	
	for i in Autoscript.AvailableFleet:
		if Autoscript.AvailableFleet[i] == route.locationFrom:
			route.vessel_id = i
			Autoscript.AvailableFleet.erase(i)
			break
	
	if route.vessel_id != null:
		Autoscript.AvailableFleet.erase(route.locationFrom)
		route.routeId = Autoscript.routeIDTracker
		route.repeating = repetetive
		Autoscript.routeIDTracker += 1
		Autoscript.PlayerRoutes.append(route)
		routePanel.get_node('RoutePanel')._populate_list()
		route._create_route()
	


func _on_select_item_selected(index):
	_update_route_information()
	
func _update_route_information():
	var vessel
	var location_from
	var location_to
	
	var location_from_name
	var location_to_name
	
	for i in Autoscript.LocationArray:
		if selectFrom.get_selected_id() == Autoscript.LocationArray[i].locationId:
			location_from = Autoscript.LocationArray[i]
		elif selectTo.get_selected_id() == Autoscript.LocationArray[i].locationId:
			location_to = Autoscript.LocationArray[i]
	
	for i in Autoscript.AvailableFleet:
		if Autoscript.AvailableFleet[i] == location_from.locationNodeName:
			vessel = Autoscript.VesselList[i]
	
	if location_from == null:
		location_from_name = 'NA'
	else:
		location_from_name = location_from.locationName
	
	if location_to == null:
		location_to_name = 'NA'
	else:
		location_to_name = location_to.locationName
	
	get_node('Control/RouteText').clear()
	get_node('Control/RouteText').add_text('Route From: %d \n Route To: %d \n Assigned Vessel: %d' % [location_from_name, location_to_name, vessel.vessel_name])


func _on_route_pressed():
	_route_creation(true)
