extends Node

var lovFrom
var lovTo

# Called when the node enters the scene tree for the first time.
func _ready():
	Autoscript.Cash = 1500
	Autoscript.Materials = 0
	Autoscript.PlayerRoutes.clear()
	
	
	Autoscript.AvailableFleet.append('Vessel1')
	Autoscript.AvailableFleet.append('Vessel2')
	
	_generateLocations()
	_generatePathways()
	
	_generateLocationArray()
	_generateSelectLists()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Autoscript.Cash <= 0:
		Autoscript.lose = true
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	elif Autoscript.Cash >= 2000:
		Autoscript.win = true
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _generateSelectLists():
	lovFrom = get_node("CanvasLayer/RoutePlanner/RoutePlanetPicker/Control/HBoxContainer/VBoxContainer/SelectFrom")
	lovTo = get_node("CanvasLayer/RoutePlanner/RoutePlanetPicker/Control/HBoxContainer/VBoxContainer2/SelectTo")
	
	for i in Autoscript.LocationNames:
		lovFrom.add_item(Autoscript.LocationNames[i], i)
		lovTo.add_item(Autoscript.LocationNames[i], i)
		
	lovFrom.selected = 0
	lovTo.selected = 0

func _generateLocationArray():
	for i in Autoscript.LocationArray:
		for j in Autoscript.LocationArray[i].locationNeighbours:
			Autoscript.LocationDistances[i] = Autoscript.LocationArray[i].locationNeighbours
	
func _generateLocations():
	for i in get_node('Planets').get_children():
		var  location : Location = Location.new()
		
		location.locationNodeName = i.name
		location.locationName = i.get_node('LocationName').get_child(0).name
		location.locationId = (Autoscript.LocationArray.size() + 5)*2
		Autoscript.LocationNames[location.locationId] = location.locationName
		Autoscript.LocationPrettyName[location.locationNodeName] = location.locationName
		Autoscript.LocationArray[location.locationNodeName] = location
	
	
func _generatePathways():
	for i in get_node('Pathways').get_children():
		var pathway : Pathways = Pathways.new()
		
		pathway.pathwayName = i.name
		pathway.locationZero = i.name.split('-', false, 2)[0]
		pathway.locationOne = i.name.split('-', false, 2)[1]
		pathway.pathwayId = Autoscript.PathwayArray.size()
		
		var locationZero : Location = Autoscript.LocationArray[pathway.locationZero]
		var locationOne : Location = Autoscript.LocationArray[pathway.locationOne]
		
		locationZero.locationNeighbours[locationOne.locationNodeName] = 150
		locationOne.locationNeighbours[locationZero.locationNodeName] = 150
		
		Autoscript.PathwayArray.append(pathway)

	
	
