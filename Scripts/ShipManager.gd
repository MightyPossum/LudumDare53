extends PathFollow3D

var vessel_id
var speed
var init_speed = 0.2
var current_position
var direction
var stop_timer
var destination
var next_destination
var origin 
var my_path : Array
var current_path
var my_assigned_route

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if speed > 0:
		if current_position >= 0.999:
			_set_speed(0)
			_check_path_and_update()
		elif current_position <= 0.001:
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
	
	origin = next_destination
	var path_existst = false
	
	if not my_path.size() <= 0:
		current_path = my_path.pop_front()
		
		_start_traveling()
		
		var next_node = get_parent().get_parent().get_node(current_path)
		get_parent().remove_child(self)
		next_node.add_child(self)
	else:
		if destination.split('',false,2)[0] == 'p':
			if Autoscript.Materials >= 500:
				Autoscript.Cash = Autoscript.Cash + 1000
				Autoscript.Materials = Autoscript.Materials - 500
		elif destination.split('',false,2)[0] == 'a':
			if Autoscript.Cash >= 250:
				Autoscript.Cash = Autoscript.Cash - 250
				Autoscript.Materials = Autoscript.Materials + 500
			
		if my_assigned_route.repeating:
			my_path = my_assigned_route.path.duplicate()
			print(my_path)
			my_path.reverse()
			_check_path_and_update()
		else:
			Autoscript.PlayerRoutes.erase(my_assigned_route)
			Autoscript.AvailableFleet[vessel_id] = origin
			get_tree().get_root().get_node("/root/GameScene/CanvasLayer/RoutePanel/RoutePanel")._populate_list()
			queue_free()

func _start_traveling():
	if origin == current_path.split('-',false,2)[0]:
		next_destination = current_path.split('-',false,2)[1]
		direction = 1
		current_position = 0.01
	elif origin == current_path.split('-',false,2)[1]:
		next_destination = current_path.split('-',false,2)[0]
		direction = -1
		current_position = 0.98
		
	set_progress_ratio(current_position)
	_set_speed(init_speed)
	

func _initalize(locationFrom, locationTo, route, routeVesselId):
	
	destination = locationTo
	origin = locationFrom
	my_path = route.path.duplicate()
	my_assigned_route = route
	vessel_id = routeVesselId
	
	current_path = my_path.pop_front()
	_start_traveling()
	
	set_progress_ratio(current_position)
