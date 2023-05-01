class_name Route extends Node3D

var routeId
var locationFrom
var locationTo
var vessel_id
var path : Array
var shipManager = load("res://Scenes/Ship.tscn")
var cost = 0
var repeating : bool = false
var repeating_cost : int = 0

func _create_route():
	
	var dijkstra_result = Autoscript.dijkstra(locationFrom, locationTo)
	var queue = dijkstra_result['path']
	
	cost = dijkstra_result['cost'][locationTo]
	Autoscript.Cash -= cost
	repeating_cost = dijkstra_result['path'].size()-1
	repeating_cost = repeating_cost * Autoscript.get_vessel(vessel_id).travel_cost * 10
	
	var current
	var next
	var pathway
	
	while queue:
		# Get the first element, the first time we traverse the queue
		if current == null:
			current = queue.pop_front()
		
		next = queue.pop_front()
		
		pathway = current + "-" + next
		
		var path_existst = false
		
		for i in Autoscript.PathwayArray.size():
			if Autoscript.PathwayArray[i].pathwayName == pathway:
				path_existst = true
		
		if path_existst == false:
			pathway = next + "-" + current
			
		current = next
		path.append(pathway)
	
	shipManager = shipManager.instantiate()
	
	get_tree().get_root().get_node('GameScene').get_node('Pathways').get_node(path[0]).add_child(shipManager)
	shipManager._initalize(locationFrom, locationTo, self, vessel_id)
	
