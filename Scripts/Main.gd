extends Node2D

var ovr_score = 0
var level1 = preload("res://Scenes/Level1.tscn")
var level2 = preload("res://Scenes/Level2.tscn")
var level3 = preload("res://Scenes/Level3.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	randomize()
	var level = randi()%3+1
	match level:
		1:
			get_tree().change_scene("res://Scenes/Level1.tscn")
		2:
			get_tree().change_scene("res://Scenes/Level2.tscn")
		3:
			get_tree().change_scene("res://Scenes/Level3.tscn")

func overall_score(score):
	ovr_score =+ score
