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
