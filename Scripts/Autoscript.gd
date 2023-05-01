extends Node

var PlayerRoutes : Array
var PlanetArray : Array
var PathwayArray : Array
var LocationArray : Dictionary
var LocationDistances : Dictionary
var DistanceCosts : Dictionary
var VesselNames : Array
var locationIdArray : Dictionary
var LocationNames : Dictionary
var LocationPrettyName : Dictionary
var AvailableFleet : Dictionary
var VesselList : Dictionary

var ShipCost : int = 500
var StationCost : int = 5000
var globalSupplyTick : int = 9
var MaterialSellConversionRate = 2
var MaterialBuyConversionRate = 1.25
var DemandConversionRate = 600

var win : bool = false
var lose : bool = false

var Cash : int = 0
var Materials : int = 0
var supplyAndDemandLimit = 1000


var routeIDTracker : int = 1

func _log_debug(log_from, var1 = ' ', var2 = ' ', var3 = ' ', var4 = ' '):
	
	print(' ')
	print('#### ' + str(log_from) + ' ####')
	print('#### ' + str(var1) + ' - ' + str(var2) + ' - ' + str(var3) + ' - ' + str(var4) + ' ####')
	print('#### Log End ####')
	print(' ')

func get_vessel(vessel_id):
	return VesselList[vessel_id]
	
func update_location_station(location):
	get_tree().get_root().get_node("GameScene").get_node('Planets').get_node(str(location.locationNodeName)).get_node('Station').visible = true
	location.locationHasStation = true
	if not (location.locationNodeName == 'a7' or location.locationNodeName == 'p1'):
		Cash -= StationCost

func _convert_materials_to_cash(amount, demand):
	return amount * MaterialSellConversionRate * (demand/DemandConversionRate)
	
func _convert_cash_to_materials(amount, demand):
	return amount * MaterialBuyConversionRate * (demand/DemandConversionRate)
	
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

func create_vessel_names_list():
	VesselNames.append('TNNS Mighty')
	VesselNames.append('TNNS Ranzor')
	VesselNames.append('TNNS Tardis')
	VesselNames.append('TNNS Covfefe')
	VesselNames.append('TNNS Stellaris')
	VesselNames.append('TNNS Europa')
	VesselNames.append('TNNS Victoria')
	VesselNames.append('TNNS Crusader')
	VesselNames.append('TNNS Enterprise')
	VesselNames.append('TNNS Odyssey')
	VesselNames.append('TNNS Atlas')
	VesselNames.append('TNNS Infinity')
	VesselNames.append('TNNS Horizon')
	VesselNames.append('TNNS Euphoria')
	VesselNames.append('TNNS Phoenix')
	VesselNames.append('TNNS Voyager')
	VesselNames.append('TNNS Aurora')
	VesselNames.append('TNNS Eclipse')
	VesselNames.append('TNNS Serenity')
	VesselNames.append('TNNS Titan')
	VesselNames.append('TNNS Artemis')
	VesselNames.append('TNNS Zenith')
	VesselNames.append('TNNS Polaris')
	VesselNames.append('TNNS Aquarius')
	VesselNames.append('TNNS Galaxy')
	VesselNames.append('TNNS Andromeda')
	VesselNames.append('TNNS Nebula')
	VesselNames.append('TNNS Pulsar')
	VesselNames.append('TNNS Celestia')
	VesselNames.append('TNNS Comet')
	VesselNames.append('TNNS Cosmos')
	VesselNames.append('TNNS Delta')
	VesselNames.append('TNNS Equinox')
	VesselNames.append('TNNS Orion')
	VesselNames.append('TNNS Quasar')
	VesselNames.append('TNNS Radiance')
	VesselNames.append('TNNS Solaris')
	VesselNames.append('TNNS Stellar')
	VesselNames.append('TNNS Supernova')
	VesselNames.append('TNNS Vega')
	VesselNames.append('TNNS Apollo')
	VesselNames.append('TNNS Cygnus')
	VesselNames.append('TNNS Helios')
	VesselNames.append('TNNS Juno')
	VesselNames.append('TNNS Lyra')
	VesselNames.append('TNNS Mercury')
	VesselNames.append('TNNS Nucleus')
	VesselNames.append('TNNS Pegasus')
	VesselNames.append('TNNS Thunderbolt')
	VesselNames.append('TNNS Triton')
	VesselNames.append('TNNS Astraeus')
	VesselNames.append('TNNS Centaurus')
	VesselNames.append('TNNS Elysium')
	VesselNames.append('TNNS Hercules')
	VesselNames.append('TNNS Hydra')
	VesselNames.append('TNNS Aquila')
	VesselNames.append('TNNS Chimera')
	VesselNames.append('TNNS Chronos')
	VesselNames.append('TNNS Delphi')
	VesselNames.append('TNNS Excalibur')
	VesselNames.append('TNNS Falcon')
	VesselNames.append('TNNS Goliath')
	VesselNames.append('TNNS Hades')
	VesselNames.append('TNNS Leviathan')
	VesselNames.append('TNNS Minerva')
	VesselNames.append('TNNS Nemesis')
	VesselNames.append('TNNS Odin')
	VesselNames.append('TNNS Onyx')
	VesselNames.append('TNNS Osiris')
	VesselNames.append('TNNS Pandora')
	VesselNames.append('TNNS Phantom')
	VesselNames.append('TNNS Poseidon')
	VesselNames.append('TNNS Prometheus')
	VesselNames.append('TNNS Pyro')
	VesselNames.append('TNNS Ragnarok')
	VesselNames.append('TNNS Raven')
	VesselNames.append('TNNS Reaper')
	VesselNames.append('TNNS Sable')
	VesselNames.append('TNNS Salem')
	VesselNames.append('TNNS Scythe')
	VesselNames.append('TNNS Shadow')
	VesselNames.append('TNNS Sphinx')
	VesselNames.append('TNNS Storm')
	VesselNames.append('TNNS Tempest')
	VesselNames.append('TNNS Thor')
	VesselNames.append('TNNS Thunder')
	VesselNames.append('TNNS Titaness')
	VesselNames.append('TNNS Typhoon')
	VesselNames.append('TNNS Valkyrie')
	VesselNames.append('TNNS Vortex')
	VesselNames.append('TNNS Warhawk')
	VesselNames.append('TNNS Whirlwind')
	VesselNames.append('TNNS Wildcat')
	VesselNames.append('TNNS Wolf')
	VesselNames.append('TNNS Wolverine')
	VesselNames.append('TNNS Wyvern')
	VesselNames.append('TNNS Yeti')
	VesselNames.append('TNNS Zeus')
	VesselNames.append('TNNS Zodiac')
	VesselNames.append('TNNS Zorro')
	VesselNames.append('TNNS Albatross')
	VesselNames.append('TNNS Bison')
	VesselNames.append('TNNS Crocodile')
	VesselNames.append('TNNS Dragonfly')
	VesselNames.append('TNNS Elephant')

	VesselNames.append('PNV Odyssey')
	VesselNames.append('PNV Atlas')
	VesselNames.append('PNV Infinity')
	VesselNames.append('PNV Horizon')
	VesselNames.append('PNV Euphoria')
	VesselNames.append('PNV Phoenix')
	VesselNames.append('PNV Voyager')
	VesselNames.append('PNV Aurora')
	VesselNames.append('PNV Eclipse')
	VesselNames.append('PNV Serenity')
	VesselNames.append('PNV Titan')
	VesselNames.append('PNV Artemis')
	VesselNames.append('PNV Zenith')
	VesselNames.append('PNV Polaris')
	VesselNames.append('PNV Aquarius')
	VesselNames.append('PNV Galaxy')
	VesselNames.append('PNV Andromeda')
	VesselNames.append('PNV Nebula')
	VesselNames.append('PNV Pulsar')
	VesselNames.append('PNV Celestia')
	VesselNames.append('PNV Comet')
	VesselNames.append('PNV Cosmos')
	VesselNames.append('PNV Delta')
	VesselNames.append('PNV Equinox')
	VesselNames.append('PNV Orion')
	VesselNames.append('PNV Quasar')
	VesselNames.append('PNV Radiance')
	VesselNames.append('PNV Solaris')
	VesselNames.append('PNV Stellar')
	VesselNames.append('PNV Supernova')
	VesselNames.append('PNV Vega')
	VesselNames.append('PNV Apollo')
	VesselNames.append('PNV Cygnus')
	VesselNames.append('PNV Helios')
	VesselNames.append('PNV Juno')
	VesselNames.append('PNV Lyra')
	VesselNames.append('PNV Mercury')
	VesselNames.append('PNV Nucleus')
	VesselNames.append('PNV Pegasus')
	VesselNames.append('PNV Thunderbolt')
	VesselNames.append('PNV Triton')
	VesselNames.append('PNV Astraeus')
	VesselNames.append('PNV Centaurus')
	VesselNames.append('PNV Elysium')
	VesselNames.append('PNV Hercules')
	VesselNames.append('PNV Hydra')
	VesselNames.append('PNV Aquila')
	VesselNames.append('PNV Chimera')
	VesselNames.append('PNV Chronos')
	VesselNames.append('PNV Delphi')
	VesselNames.append('PNV Excalibur')
	VesselNames.append('PNV Falcon')
	VesselNames.append('PNV Goliath')
	VesselNames.append('PNV Hades')
	VesselNames.append('PNV Leviathan')
	VesselNames.append('PNV Minerva')
	VesselNames.append('PNV Nemesis')
	VesselNames.append('PNV Odin')
	VesselNames.append('PNV Onyx')
	VesselNames.append('PNV Osiris')
	VesselNames.append('PNV Pandora')
	VesselNames.append('PNV Phantom')
	VesselNames.append('PNV Poseidon')
	VesselNames.append('PNV Prometheus')
	VesselNames.append('PNV Pyro')
	VesselNames.append('PNV Ragnarok')
	VesselNames.append('PNV Raven')
	VesselNames.append('PNV Reaper')
	VesselNames.append('PNV Sable')
	VesselNames.append('PNV Salem')
	VesselNames.append('PNV Scythe')
	VesselNames.append('PNV Shadow')
	VesselNames.append('PNV Sphinx')
	VesselNames.append('PNV Storm')
	VesselNames.append('PNV Tempest')
	VesselNames.append('PNV Thor')
	VesselNames.append('PNV Thunder')
	VesselNames.append('PNV Titaness')
	VesselNames.append('PNV Typhoon')
	VesselNames.append('PNV Valkyrie')
	VesselNames.append('PNV Vortex')
	VesselNames.append('PNV Warhawk')
	VesselNames.append('PNV Whirlwind')
	VesselNames.append('PNV Wildcat')
	VesselNames.append('PNV Wolf')
	VesselNames.append('PNV Wolverine')
	VesselNames.append('PNV Wyvern')
	VesselNames.append('PNV Yeti')
	VesselNames.append('PNV Zeus')
	VesselNames.append('PNV Zodiac')
	VesselNames.append('PNV Zorro')
	VesselNames.append('PNV Albatross')
	VesselNames.append('PNV Bison')
	VesselNames.append('PNV Crocodile')
	VesselNames.append('PNV Dragonfly')
	VesselNames.append('PNV Elephant')
