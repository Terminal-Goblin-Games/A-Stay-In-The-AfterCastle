extends Node2D
var dmg = 25

# Declare member variables here. Examples:
# var a = 2
# var b = "text""
onready var player = get_parent().get_parent().get_parent() # wtf
var is_shake = false
var shake_amt = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_shake:
		player.shake_cam()
	else:
		player.set_cam_back()


func _on_Area2D_body_entered(body):
	print(body.get_name())
	if body.get_name() != "Sword" && body.get_name() != "TileMap" && body.get_name() != "Player":
		if body.is_in_group("hittable"):
			body.hit()
		if body.is_in_group("enemies") && is_instance_valid(body):
			body.hit(dmg)
		is_shake = true
		yield(get_tree().create_timer(0.05),"timeout")
		is_shake = false
	else:
		pass
		

