extends Control

var selectedLocation
var vesselCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if selectedLocation:
			get_node("Panel").get_node('SupplyOrDemand').get_node('SupplyOrDemandLabel').text = str(selectedLocation.supplyAndDemand)
			vesselCount = 0
			for i in Autoscript.AvailableFleet:
				
				if Autoscript.AvailableFleet[i] == selectedLocation.locationNodeName:
					vesselCount += 1
			get_node("Panel").get_node('ParkedVessels').get_node('ParkedVesselsLabel').text = str(vesselCount)
			if vesselCount > 0 and not selectedLocation.locationHasStation:
				get_node("Panel").get_node('StationButton').disabled = false
				get_node("Panel").get_node('StationButton').get_node('StationStatusLabel').visible = false
			elif selectedLocation.locationHasStation:
				get_node("Panel").get_node('StationButton').disabled = true
				get_node("Panel").get_node('StationButton').get_node('StationStatusLabel').visible = true
				get_node("Panel").get_node('StationButton').get_node('StationStatusLabel').text = 'Station On Location'
			else:
				get_node("Panel").get_node('StationButton').disabled = true
				get_node("Panel").get_node('StationButton').get_node('StationStatusLabel').visible = true
				get_node("Panel").get_node('StationButton').get_node('StationStatusLabel').text = 'No vessel in Orbit'
				

func _toggle_info_panel(location):
		
		if selectedLocation == location:
			visible = not visible
			selectedLocation = null
		elif selectedLocation != location:
			selectedLocation = location
			if not visible:
				visible = not visible
		
		if selectedLocation:
			get_node("Panel").get_node('LocationName').text = selectedLocation.locationName
			get_node("Panel").get_node('DemandRate').get_node('DemandRateLabel').text = _convert_supply_rate(selectedLocation.supplyAndDemandRate)
			
			if selectedLocation.locationNodeName.split('',false,2)[0] == 'a':
				get_node("Panel").get_node('SupplyOrDemand').text ='Supply'
			else:
				get_node("Panel").get_node('SupplyOrDemand').text ='Demand'
		
		
func _convert_supply_rate(supplyAndDemandRate):
	if supplyAndDemandRate > 0.51:
		return 'High'
	elif supplyAndDemandRate == 0:
		return 'No'
	elif supplyAndDemandRate < 0.5:
		return 'Low'
	else:
		return 'Normal'


func _on_station_button_pressed():
	Autoscript.update_location_station(selectedLocation)
