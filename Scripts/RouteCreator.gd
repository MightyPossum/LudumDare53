extends Control

var SelectFrom
var SelectTo
var ApplyButton
var RoutePlanner
var RoutePanel
var planetFrom
var planetTo

# Called when the node enters the scene tree for the first time.
func _ready():
	SelectFrom = get_node("Control/HBoxContainer/VBoxContainer/SelectFrom")
	SelectTo = get_node("Control/HBoxContainer/VBoxContainer2/SelectTo")
	ApplyButton = get_node("Control/HBoxContainer/VBoxContainer2/Apply")
	RoutePlanner = get_parent().get_parent().get_node('RoutePlanner')
	RoutePanel = get_parent().get_parent().get_node('RoutePanel')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if SelectFrom.selected == 0 or SelectTo.selected == 0:
		ApplyButton.disabled = true
	else:
		ApplyButton.disabled = false

func _on_cancel_pressed():
	# Menu Navigation
	RoutePlanner.visible = false
	RoutePanel.visible = true

func _on_apply_pressed():
	## Menu navigation
	RoutePlanner.visible = false
	RoutePanel.visible = true
	
	# Logic
	var PlanetFrom = SelectFrom.get_item_text(SelectFrom.selected)
	var PlanetTo = SelectTo.get_item_text(SelectTo.selected)
	
	print(PlanetFrom + '  ' + PlanetTo)
	Autoscript.PlayerRoutes[PlanetFrom] = PlanetTo
	print(Autoscript.PlayerRoutes)
