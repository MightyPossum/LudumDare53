extends PathFollow3D

var speed
var init_speed = 0.1
var current_position
var direction
var stop_timer
var destination
var next_destination
var origin 
var my_path : Array
var current_path
var my_assigned_route
var current_location
var vessel : Ship

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if speed > 0:
		if current_position >= 1:
			_set_speed(0)
			_check_path_and_update()
		elif current_position <= 0:
			_set_speed(0)
			_check_path_and_update()
		
		current_position += delta * speed * direction
	
		set_progress_ratio(current_position)

func _set_speed(speed_number):
	speed = speed_number
	
func _update_path(path):
	my_path = path
	current_path = my_path.pop_front()

func _check_path_and_update():
	
	var path_existst = false
	
	if not my_path.size() <= 0:
		
		current_path = my_path.pop_front()
		current_location = next_destination
		
		_start_traveling()
		
		var next_node = get_parent().get_parent().get_node(current_path)
		get_parent().remove_child(self)
		next_node.add_child(self)
	else:
		if current_location.split('',false,2)[0] == 'p':
			if Autoscript.Materials >= 500:
				Autoscript.Cash = Autoscript.Cash + 1000
				Autoscript.Materials = Autoscript.Materials - 500
		elif current_location.split('',false,2)[0] == 'a':
			if Autoscript.Cash >= 250:
				Autoscript.Cash = Autoscript.Cash - 250
				Autoscript.Materials = Autoscript.Materials + 500
			
		if my_assigned_route.repeating:
			my_path = my_assigned_route.path.duplicate()
			my_assigned_route.path.reverse()
			my_path.reverse()
			Autoscript._log_debug('now repeating', 'current location: ' + current_location, 'destination: ' + destination, 'origin: ' + origin, 'destination: ' + destination)
			current_location = destination
			var temp_origin = origin
			origin = destination
			destination = temp_origin
			Autoscript._log_debug('variables updated', 'current location: ' + current_location, 'destination: ' + destination, 'origin: ' + origin, 'destination: ' + destination)
			
			if Autoscript.Cash >= 100:
				Autoscript.Cash = Autoscript.Cash + 0
			_check_path_and_update()
		else:
			Autoscript.PlayerRoutes.erase(my_assigned_route)
			Autoscript.AvailableFleet[vessel.vessel_id] = destination
			get_tree().get_root().get_node("/root/GameScene/CanvasLayer/RoutePanel/RoutePanel")._populate_list()
			queue_free()

func _start_traveling():
	Autoscript._log_debug('start_traveling', current_location, current_path, current_path.split('-',false,2)[0], current_path.split('-',false,2)[1])
	Autoscript._log_debug('directions', 'first if: ' + str(current_location == current_path.split('-',false,2)[0]), 'Second if: ' + str(current_location == current_path.split('-',false,2)[1]))
	
	if current_location == current_path.split('-',false,2)[0]:
		next_destination = current_path.split('-',false,2)[1]
		direction = 1
		get_child(0).rotation_degrees.y = 90
		current_position = 0.01
	elif current_location == current_path.split('-',false,2)[1]:
		next_destination = current_path.split('-',false,2)[0]
		direction = -1
		get_child(0).rotation_degrees.y = -90
		current_position = .99
	
	Autoscript._log_debug('Set Starting Location', 'Current Posisiton: ' + str(current_position), 'Current Location: ' + str(current_location), 'Next Destination: ' + str(next_destination), 'Current Path: ' + str(current_path))
	set_progress_ratio(current_position)
	_set_speed(init_speed)
	

func _initalize(locationFrom, locationTo, route, routeVesselId):
	
	destination = locationTo
	origin = locationFrom
	current_location = locationFrom
	my_path = route.path.duplicate()
	my_assigned_route = route
	vessel = Autoscript.get_vessel(routeVesselId)
	
	current_path = my_path.pop_front()
	
	Autoscript._log_debug('line 106 ShipManager', origin, destination, current_position, current_location)
	
	_start_traveling()
	
	#set_progress_ratio(current_position)
