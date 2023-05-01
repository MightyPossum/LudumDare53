extends Control

var selectFrom
var selectTo
var applyButton
var routeButton
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
	routeButton = get_node("Control/Route")
	routePlanner = get_parent().get_parent().get_node('RoutePlanner')
	routePanel = get_parent().get_parent().get_node('RoutePanel')
	routePanelItemList = routePanel.get_node("RoutePanel").get_node("RoutePanelRoot").get_node('ItemList')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		visible = false
	if (selectFrom.selected == 0 or selectTo.selected == 0) or (selectFrom.get_selected_id() == selectTo.get_selected_id()):
		applyButton.disabled = true
		routeButton.disabled = true
	elif Autoscript.locationIdArray[selectTo.get_selected_id()].locationHasStation == false:
		applyButton.disabled = false
		routeButton.disabled = true
	else:
		applyButton.disabled = false
		routeButton.disabled = false

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
	
	var cost : int = 0
	var repeating_cost : int = 0
	
	var vessel_name = ' '
	
	for i in Autoscript.locationIdArray:
		if selectFrom.get_selected_id() == Autoscript.locationIdArray[i].locationId:
			location_from = Autoscript.locationIdArray[i]
		elif selectTo.get_selected_id() == Autoscript.locationIdArray[i].locationId:
			location_to = Autoscript.locationIdArray[i]
	
	if location_from:
		for i in Autoscript.AvailableFleet:
			if Autoscript.AvailableFleet[i] == location_from.locationNodeName:
				vessel = Autoscript.VesselList[i]
				vessel_name = vessel.vessel_name
	
	if location_from == null:
		location_from_name = 'NA'
	else:
		location_from_name = location_from.locationName
	
	if location_to == null:
		location_to_name = 'NA'
	else:
		location_to_name = location_to.locationName
	
	if location_from and location_to:
		var dijkstra_result = Autoscript.dijkstra(location_from.locationNodeName, location_to.locationNodeName)
		cost = dijkstra_result['cost'][location_to.locationNodeName]
		repeating_cost = dijkstra_result['path'].size()-1
		repeating_cost = repeating_cost * vessel.travel_cost * 10
	
	get_node('Control/RouteText').clear()
	get_node('Control/RouteText').append_text('[b]Route From[/b]\n' + location_from_name + '\n[b]Route To[/b]\n' + location_to_name + '\n[b]Assigned Vessel[/b]\n' + vessel_name + '\n[b]inital Cost[/b]\n' + str(cost) + '\n[b]Repeating Cost[/b]\n' + str(repeating_cost))


func _on_route_pressed():
	_route_creation(true)
