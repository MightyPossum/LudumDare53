extends Node

var lovFrom
var lovTo
@onready var route_planner = get_node("CanvasLayer/RoutePlanner/RoutePlanetPicker")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Autoscript.create_vessel_names_list()
	Autoscript.Cash = 5000
	Autoscript.Materials = 0
	Autoscript.PlayerRoutes.clear()
	
	var ship : Ship = Ship.new()
	Autoscript.VesselNames.shuffle()
	ship._init_ship(Autoscript.VesselNames.pop_front(),Autoscript.VesselList.size()+1)
	Autoscript.VesselList[ship.vessel_id] = ship
	Autoscript.AvailableFleet[ship.vessel_id] = 'p1'
	
	ship = Ship.new()
	Autoscript.VesselNames.shuffle()
	ship._init_ship(Autoscript.VesselNames.pop_front(),Autoscript.VesselList.size()+1)
	Autoscript.VesselList[ship.vessel_id] = ship
	Autoscript.AvailableFleet[ship.vessel_id] = 'p1'
	
	_generateLocations()
	_generatePathways()
	
	_generateLocationArray()
	_generateSelectLists()
	
	
	route_planner._create_route('p1', 'a7', true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Autoscript.Cash <= 0:
		Autoscript.lose = true
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	elif Autoscript.Cash >= 200000:
		Autoscript.win = true
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _generateSelectLists():
	lovFrom = get_node("CanvasLayer/RoutePlanner/RoutePlanetPicker/Control/HBoxContainer/VBoxContainer/SelectFrom")
	lovTo = get_node("CanvasLayer/RoutePlanner/RoutePlanetPicker/Control/HBoxContainer/VBoxContainer2/SelectTo")
	
	lovFrom.clear()
	lovTo.clear()
	
	lovFrom.add_separator('Origin')
	lovTo.add_separator('Destination')
	
	for i in Autoscript.LocationNames:
		var vessel_present = false
		for j in Autoscript.AvailableFleet:
			if Autoscript.AvailableFleet[j] == Autoscript.LocationNames[i][1]:
				vessel_present = true
				
		if vessel_present:
			lovFrom.add_item(Autoscript.LocationNames[i][0], i)
		lovTo.add_item(Autoscript.LocationNames[i][0], i)
		
	lovFrom.selected = 0
	lovTo.selected = 0

func _generateLocationArray():
	for i in Autoscript.LocationArray:
		for j in Autoscript.LocationArray[i].locationNeighbours:
			Autoscript.LocationDistances[i] = Autoscript.LocationArray[i].locationNeighbours
	
func _generateLocations():
	for i in get_node('Planets').get_children():
		var locationHasStation = false
		var location : Location_Object = Location_Object.new()
		
		var locationId =(Autoscript.LocationArray.size() + 5)*2
		Autoscript.LocationNames[locationId] = [i.get_node('LocationName').get_child(0).name,i.name]
		Autoscript.LocationPrettyName[i.name] = i.get_node('LocationName').get_child(0).name
		Autoscript.LocationArray[i.name] = location
		if i.name == 'p1' or i.name == 'a7':
			locationHasStation = true
		
		location._initialize(i.name,i.get_node('LocationName').get_child(0).name,locationId,i.demand,i.demand_rate,locationHasStation)
		
		
		Autoscript.locationIdArray[locationId] = Autoscript.LocationArray[location.locationNodeName]
		
	
func _generatePathways():
	for i in get_node('Pathways').get_children():
		var pathway : Pathways = Pathways.new()
		
		pathway.pathwayName = i.name
		pathway.locationZero = i.name.split('-', false, 2)[0]
		pathway.locationOne = i.name.split('-', false, 2)[1]
		pathway.pathwayId = Autoscript.PathwayArray.size()
		
		var locationZero : Location_Object = Autoscript.LocationArray[pathway.locationZero]
		var locationOne : Location_Object = Autoscript.LocationArray[pathway.locationOne]
		
		locationZero.locationNeighbours[locationOne.locationNodeName] = 150
		locationOne.locationNeighbours[locationZero.locationNodeName] = 150
		
		Autoscript.PathwayArray.append(pathway)
	
func _on_timer_timeout():	
	for i in Autoscript.locationIdArray:
		Autoscript.locationIdArray[i]._tick_demand()
