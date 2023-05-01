extends PathFollow3D

var progress_speed = .5
var cur_pos = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_child_count() >= 2:
		visible = true
		cur_pos += (progress_speed * delta)
		set_progress_ratio(cur_pos)
	else:
		visible = false
