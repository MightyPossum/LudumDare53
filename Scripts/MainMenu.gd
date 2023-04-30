extends Control

@onready var scene_label = $SceneLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	if Autoscript.win:
		scene_label.text = 'You Win, have a cookie'
	elif Autoscript.lose:
		scene_label.text = 'You lose, have a cookie'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Autoscript.win = false
	Autoscript.lose = false
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
