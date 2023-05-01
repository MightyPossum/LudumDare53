class_name Location_Object extends Object

var locationNodeName
var locationName
var locationId
var locationHasStation : bool = false
var supplyAndDemand : int
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
	if not supplyAndDemand >= Autoscript.supplyAndDemandLimit and locationHasStation:
		var supplyTick
		if locationNodeName.split('',false,2)[0] == 'p':
			supplyTick = Autoscript.globalSupplyTick + 2
		else:
			supplyTick = Autoscript.globalSupplyTick
			
		supplyAndDemand += Autoscript.globalSupplyTick * supplyAndDemandRate
		
		if supplyAndDemand > Autoscript.supplyAndDemandLimit:
			supplyAndDemand = Autoscript.supplyAndDemandLimit

func _sell_materials(amount):
	if not locationHasStation:
		return amount
		
	var left_over = 0
	if supplyAndDemand >= amount:
		Autoscript.Cash += Autoscript._convert_materials_to_cash(amount, supplyAndDemand)
	else:
		left_over = amount - supplyAndDemand
		Autoscript.Cash += Autoscript._convert_materials_to_cash(amount-left_over, supplyAndDemand)
		
	supplyAndDemand -= (amount-left_over)
	if supplyAndDemand < 0:
		supplyAndDemand = 0
	return left_over

func _buy_materials(amount):
	if not locationHasStation:
		return 0
	
	var amount_purchased = 0
	if supplyAndDemand >= amount:
		Autoscript.Cash -= Autoscript._convert_cash_to_materials(amount, supplyAndDemand)
		amount_purchased = amount
	else:
		amount_purchased = supplyAndDemand
		Autoscript.Cash += Autoscript._convert_materials_to_cash(amount_purchased, supplyAndDemand)

	supplyAndDemand -= (amount_purchased)
	if supplyAndDemand < 0:
		supplyAndDemand = 0
		
	return amount_purchased
