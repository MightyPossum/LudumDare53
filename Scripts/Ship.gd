class_name Ship extends Node3D

var vessel_name
var vessel_id
var vessel_storage_space : int = 0
var materials_in_storage : int = 0
var vessel_speed
var vessel_location
var travel_cost

func _init_ship(vesselName, vesselId, vesselStorageSpace = 500, vesselSpeed = 50, travelCost = 5):
	vessel_name = vesselName
	vessel_id = vesselId
	vessel_storage_space = vesselStorageSpace
	vessel_speed = vesselSpeed 
	travel_cost = travelCost
  
func _add_materials_to_storage(amount):
	var left_over
	
	materials_in_storage += amount
	if materials_in_storage > vessel_storage_space:
		left_over = materials_in_storage - vessel_storage_space
	
	return left_over
	
func _set_materials_in_storage(amount):
	materials_in_storage = amount
