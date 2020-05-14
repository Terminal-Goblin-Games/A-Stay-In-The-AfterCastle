extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum states {IDLE, BREAKING, DEAD}
var state = states.IDLE
var last_state = states.IDLE
var goblet = preload("res://Scenes/Goblet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("hittable")
	state = states.IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_machine()
	last_state = state

func state_machine():
	match state:
		states.IDLE:
			$AnimationPlayer.play("idle")
		states.BREAKING:
			$AnimationPlayer.play("break")
			
		states.DEAD:
			var gob = goblet.instance()
			gob.set_position(position)
			get_parent().add_child(gob)
			queue_free()
func hit():
	state = states.BREAKING
	print("I'm hit")


func _on_AnimationPlayer_animation_finished(anim_name):
	if last_state == states.IDLE:
		state = states.IDLE
	else:
		state = states.DEAD
