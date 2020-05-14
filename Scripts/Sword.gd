extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Credit: Game Endeavor https://github.com/GameEndeavor/CollabJam
# His channel: https://www.youtube.com/channel/UCLweX1UtQjRjj7rs_0XQ2Eg
# Video I saw this in: https://www.youtube.com/watch?v=u0GZKJGeQLY&t=343s
func aim_at_target(target_position : Vector2):
	var angle = target_position.angle()
	position.x = cos(angle) * 50
	position.y = sin(angle) * 50
	rotation = angle
	show_behind_parent = false if angle >= 0 else true
	look_at(get_global_mouse_position())



func attack(target_position):
	get_angle_to(target_position)


func _on_Area2D_body_entered(body):
		if body.has_method("hit"):
			body.hit()


func _on_Area2D_area_entered(area):
	if area.has_method("hit"):
			area.hit()
