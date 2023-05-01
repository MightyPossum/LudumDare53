extends Node

var PlayerRoutes : Array
var PlanetArray : Array
var PathwayArray : Array
var LocationArray : Dictionary
var LocationDistances : Dictionary
var DistanceCosts : Dictionary

var win : bool = false
var lose : bool = false

var Cash : int = 0
var Materials : int = 0

var LocationNames : Dictionary
var LocationPrettyName : Dictionary

var AvailableFleet : Dictionary
var VesselList : Dictionary

var routeIDTracker : int = 1

func _log_debug(log_from, var1 = ' ', var2 = ' ', var3 = ' ', var4 = ' '):
	
	print(' ')
	print('#### ' + str(log_from) + ' ####')
	print('#### ' + str(var1) + ' - ' + str(var2) + ' - ' + str(var3) + ' - ' + str(var4) + ' ####')
	print('#### Log End ####')
	print(' ')

func get_vessel(vessel_id):
	return VesselList[vessel_id]

# define a function that implements Dijkstra's algorithm
func dijkstra(start, end):
	var graph = Autoscript.LocationDistances
	# check if the starting node is in the graph and has neighbors
	if not graph.has(start) or len(graph[start]) == 0:
		return {}

	# initialize the cost and visited arrays
	var cost = {}
	var visited = {}
	var previous = {}
	var queue = []
	var infinity = 100000000000
	
	for node in graph:
		cost[node] = infinity
		visited[node] = false
		previous[node] = null

	# set the cost of the starting node to zero and add it to the queue
	cost[start] = 0
	queue.append(start)

	# loop while the queue is not empty
	while len(queue) > 0:
		# get the node with the lowest cost from the queue
		var current = null
		var current_cost = infinity
		
		for node in queue:
			if cost[node] < current_cost:
				current = node
				current_cost = cost[node]

		# mark the current node as visited and remove it from the queue
		visited[current] = true
		if current in queue:
			queue.erase(current)

		# update the cost of each neighbor of the current node
		for neighbor in graph[current]:
			if not visited[neighbor]:
				var new_cost = cost[current] + graph[current][neighbor]
				if new_cost < cost[neighbor]:
					cost[neighbor] = new_cost
					previous[neighbor] = current
					queue.append(neighbor)
					
	# build the shortest path from the start node to the end node
	var path = []
	var current_node = end
	while current_node != null:
		path.insert(0, current_node)
		current_node = previous[current_node]

	# return the cost array
	return { "cost": cost, "path": path }
