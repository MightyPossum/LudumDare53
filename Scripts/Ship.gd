class_name Ship extends Node3D

var vessel_name
var vessel_id
var vessel_storage_space
var vessel_speed
var vessel_location
var travel_cost

func _init_ship(vesselName, vesselId, vesselStorageSpace = 500, vesselSpeed = 50, travelCost = 5):
	vessel_name = vesselName
	vessel_id = vesselId
	vessel_storage_space = vesselStorageSpace
	vessel_speed = vesselSpeed 
	travel_cost = travelCost
  
