extends CollisionShape3D

var paths_initialzed = false
var paths_array = []
var paths_direction = {}
var planet_designation
var ship

#remove these when making ship selection dynamic
var other_name

# Called when the node enters the scene tree for the first time.
func _ready():
	planet_designation = get_parent().name
	if planet_designation == 'p1':
		other_name = 'p2'
	else:
		other_name = 'p1'
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(camera, event, position, normal, shape_idx):
	if not paths_initialzed:
		for i in get_parent().get_parent().get_parent().get_node('Pathways').get_children():
			if i.name.contains(planet_designation) and i.name != planet_designation:
				paths_array.append(i)
		
		for i in paths_array:
			var counter = 0
			for j in i.name.split("-", false, 2):
				if j == planet_designation:
					paths_direction[i] = counter
				counter += 1
		
	else:
		for i in paths_direction:
			pass
	
	
	paths_initialzed = true
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed==true:
		ship = get_parent().get_parent().get_node('Pathways').get_node('p1-p2').get_node('Ship')
		if ship.current_location == planet_designation:
			ship.speed = .2
			ship.current_location = other_name
			ship.destination = planet_designation
