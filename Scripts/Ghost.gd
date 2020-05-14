extends KinematicBody2D

var max_hp = 100
var current_hp = 100
var max_dmg = 100
var current_dmg = 25
onready var player = get_parent().get_node("Player")
onready var timer = get_parent().get_node("Player/CanvasLayer/GameTime")
var speed = 50
var velocity = Vector2.ZERO
var can_hit = true
enum states {IDLE, WALKING, HURT, DEAD}
var state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_machine()
	set_phase()

func _on_Area2D_body_entered(body):
	if can_hit:
		if body.get_name() == "Player":
			body.hit(current_dmg, self.get_name())

func hit(dmg):
	state = states.HURT
	current_hp -= dmg
	if current_hp <= 0:
		state = states.DEAD

func chase_player(velocity):
	var dir
	if player != null: 
		velocity = (player.global_position - global_position).normalized() * speed
	move_and_slide(velocity)

func _on_Player_Detect_body_entered(body):
	if body.get_name() == "Player":
		player = body

func state_machine():
	match state:
		states.IDLE:
			$AnimationPlayer.play("Idle")
			chase_player(velocity)
		states.WALKING:
			$AnimationPlayer.play("Walking")
			chase_player(velocity)
		states.DEAD:
			can_hit = false
			$AnimationPlayer.play("Dead")
			
		states.HURT:
			can_hit = false
			$AnimationPlayer.play("Hurt")

func _on_AnimationPlayer_animation_finished(anim_name):
	if state != states.DEAD:
		state = states.IDLE
		can_hit = true
	else:
		player.score(15)
		queue_free()

# Handles our phase setting based on the timer node of this scene
# Note that this timer is independant of the main game timer from the player
func set_phase():
	if timer.time_left < 30 && timer.time_left >= 15:
		modulate.a = 0.5
		if current_hp > 50:
			current_hp = 50
		current_dmg = 50
		speed = 75
	if timer.time_left < 15:
		modulate.a = 0.3
		if current_hp > 25:
			current_hp = 25
		current_dmg = 100
		speed = 100
