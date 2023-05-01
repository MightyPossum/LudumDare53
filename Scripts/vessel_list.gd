extends Control

@onready var item_list = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Autoscript.Cash <= Autoscript.ShipCost:
		$AddVessel.disabled = true
	else:
		$AddVessel.disabled = false


func _on_close_pressed():
	visible = false

func _update_vessel_list():

	var location_text

	item_list.clear()
	for vessel_id in Autoscript.VesselList:
		var vessel : Ship = Autoscript.VesselList[vessel_id]
		
		if Autoscript.AvailableFleet.has(vessel.vessel_id):
			location_text = Autoscript.LocationPrettyName[Autoscript.AvailableFleet[vessel.vessel_id]]
			
		for current_route in Autoscript.PlayerRoutes:
			if current_route.vessel_id == vessel.vessel_id:
				if current_route.repeating:
					location_text = Autoscript.LocationPrettyName[current_route.locationFrom] + ' <-> ' + Autoscript.LocationPrettyName[current_route.locationTo]
				else:
					location_text = Autoscript.LocationPrettyName[current_route.locationFrom] + ' -> ' + Autoscript.LocationPrettyName[current_route.locationTo]
		
		item_list.add_item(vessel.vessel_name + ' - ' + location_text)

func _on_add_vessel_pressed():
	Autoscript.Cash -= Autoscript.ShipCost
	var ship : Ship = Ship.new()
	Autoscript.VesselNames.shuffle()
	ship._init_ship(Autoscript.VesselNames.pop_front(),Autoscript.VesselList.size()+1)
	Autoscript.VesselList[ship.vessel_id] = ship
	Autoscript.AvailableFleet[ship.vessel_id] = 'p1'
	
	_update_vessel_list()
