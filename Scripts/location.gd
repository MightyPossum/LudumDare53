class_name Location_Object extends Object



var locationNodeName
var locationName
var locationId
var locationHasStation : bool = false
var supplyAndDemand
var supplyAndDemandRate

var locationNeighbours : Dictionary

func _initialize(location_node_name, location_name, location_id, supply_and_demand = 0, supply_and_demand_rate = 0, location_has_station = false):
	locationNodeName = location_node_name
	locationName = location_name
	locationId = location_id
	locationHasStation = location_has_station
	supplyAndDemand = supply_and_demand
	supplyAndDemandRate = supply_and_demand_rate
	
	if locationHasStation:
		Autoscript.update_location_station(self)

func _tick_demand():
	if not supplyAndDemand >= Autoscript.supplyAdnDemandLimit and locationHasStation:
		supplyAndDemand += Autoscript.globalSupplyTick * supplyAndDemandRate
