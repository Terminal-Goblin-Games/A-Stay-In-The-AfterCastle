extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 500
var acceleration = 0.5
var friction = 0.3

enum states {IDLE, WALKING, DEAD, HURT}
enum act_states {IDLE,ATTACKING, ATTACKING_UP, ATTACKING_DOWN}
var state = states.IDLE
var act_state = act_states.IDLE

var score = 0
var max_hp = 100
var current_hp = 100
var dmg = 25
var can_be_hit = true
var can_input = true

var main = Main

var shake_amt = 15
var is_shake = false
# Handles our input
func get_input():
	if can_input:
		var dir = Vector2.ZERO
		if Input.is_action_pressed("up"):
			dir = Vector2(0,-1)
		if Input.is_action_pressed("down"):
			dir = Vector2(0,1)
		if Input.is_action_pressed("left"):
			dir = Vector2(-1,0)
			set_sprites_and_hb("LEFT")
		if Input.is_action_pressed("right"):
			dir = Vector2(1,0)
			set_sprites_and_hb("RIGHT")
		if Input.is_action_just_pressed("attack"):
			if dir == Vector2(0,-1):
				act_state = act_states.ATTACKING_UP
				set_sprites_and_hb("UP")
			elif dir == Vector2(0,1):
				act_state = act_states.ATTACKING_DOWN
				set_sprites_and_hb("DOWN")
			else:
				act_state = act_states.ATTACKING
		if dir != Vector2.ZERO:
			state = states.WALKING
			velocity = lerp(velocity, dir * speed, acceleration)
		else:
			state = states.IDLE
			velocity = Vector2.ZERO
			#velocity = lerp(velocity.x, velocity.y, friction)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2.visible = false
	$Sprite2/Area2D.monitoring = false
	$Sprite2.modulate.a = .7
	$CanvasLayer/VBoxContainer/Hp_Bar.value = current_hp
	$"CanvasLayer/ GameOverScreen".visible = false
	$CanvasLayer/NightFinishScreen.visible = false
	$CanvasLayer/GameTime.start()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_machine()
	get_input()
	move_and_slide(velocity)
	update_score()
	update_timer()
	if is_shake:
		shake_cam()
	else:
		set_cam_back()
# Handles our state, used for animation, etc
func state_machine():
	match state:
		states.IDLE:
			match act_state:
				act_states.IDLE:
					$AnimationPlayer.play("Idle")
				act_states.ATTACKING:
					$AnimationPlayer.play("Attacking")
					attack()
				act_states.ATTACKING_UP:
					$AnimationPlayer.play("Attacking_Up")
					attack()
				act_states.ATTACKING_DOWN:
					$AnimationPlayer.play("Attacking_Down")
					attack()
		states.WALKING:
			match act_state:
				act_states.IDLE:
					$AnimationPlayer.play("Walking")
				act_states.ATTACKING:
					$AnimationPlayer.play("Attacking")
					attack()
				act_states.ATTACKING_UP:
					$AnimationPlayer.play("Attacking_Up")
					attack()
				act_states.ATTACKING_DOWN:
					$AnimationPlayer.play("Attacking_Down")
					attack()
				act_states.ATTACKING_UP:
					$AnimationPlayer.play("Attacking_Up")
					attack()
				act_states.ATTACKING_DOWN:
					$AnimationPlayer.play("Attacking_Down")
					attack()
		states.HURT:
			can_be_hit = false
			$Sprite2.visible = false
			$Sprite2/Area2D.monitoring = false
			$AnimationPlayer.play("Hurt")
			is_shake = true
			can_input = false
			yield(get_tree().create_timer(0.05),"timeout")
			is_shake = false
			
		states.DEAD:
			$AnimationPlayer.play("Dead")
			can_input = false
			$CanvasLayer/GameTime.stop()
			$"CanvasLayer/ GameOverScreen".visible = true
			$"CanvasLayer/ GameOverScreen/Score".text = String(main.ovr_score)

func attack():
	$Sprite2/Area2D.monitoring = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if state != states.DEAD:
		state = states.IDLE
		act_state = act_states.IDLE
		can_be_hit = true
	yield(get_tree().create_timer(0.3),"timeout")
	$Sprite2/Area2D.monitoring = false
	can_input = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("hittable"):
		body.hit()
		is_shake = true
		yield(get_tree().create_timer(0.05),"timeout")
		is_shake = false
	if body.is_in_group("enemies") && is_instance_valid(body):
		is_shake = true
		body.hit(dmg)
		yield(get_tree().create_timer(0.05),"timeout")
		is_shake = false
func score(num):
	score += num

func update_score():
	$CanvasLayer/VBoxContainer/HBoxContainer/Score.text = String(score)

func update_timer():
	$CanvasLayer/Timer.text = String($CanvasLayer/GameTime.time_left)

func hit(dmg, name):
	if can_be_hit:
		state = states.HURT
		knockback(name)
		current_hp -= dmg
		if current_hp <= 0:
			state = states.DEAD
		$CanvasLayer/VBoxContainer/Hp_Bar.value = current_hp

func set_sprites_and_hb(dir):
	if dir == "RIGHT":
		$Sprite.scale.x = 1
		$Sprite2.scale.x = -2
		$Sprite2.position = Vector2(32.466,-3.788)
		$Sprite2.rotation = 179.3
		#$Sprite2.scale = Vector2(3,1)
	if dir == "LEFT":
		$Sprite.scale.x = -1
		$Sprite2.scale.x = 2
		$Sprite2.position = Vector2(-36.049, -3.788)
		$Sprite2.rotation = 179.3
		#$Sprite2.scale = Vector2(3,1)
	if dir == "UP":
		$Sprite2.position = Vector2(0.844,-32.373)
		$Sprite2.scale.x = -1
		$Sprite2.rotation = 90.2
		#$Sprite2.scale = Vector2(3,1)
	if dir == "DOWN":
		$Sprite2.position = Vector2(-2.762,29.208)
		$Sprite2.scale.x = 1
		$Sprite2.rotation = 190.8
		#$Sprite2.scale = Vector2(3,1)
func knockback(name):
	var pos = get_parent().get_node(name).global_position
	velocity = (global_position + pos).normalized() * speed
	#move_and_slide(velocity)


func _on_Restart_Button_button_down():
	randomize()
	var level = randi()%3+1
	match level:
		1:
			get_tree().change_scene("res://Scenes/Level1.tscn")
		2:
			get_tree().change_scene("res://Scenes/Level2.tscn")
		3:
			get_tree().change_scene("res://Scenes/Level3.tscn")


func _on_GameTime_timeout():
	main.overall_score(score)
	$CanvasLayer/NightFinishScreen/NightScore.text = "Night score: " + String(score)
	$CanvasLayer/NightFinishScreen/OverScore.text = "Overall score: " + String(main.ovr_score)
	$CanvasLayer/NightFinishScreen.visible = true
	get_tree().paused = true
	$CanvasLayer/GameTime.stop()


func _on_NextNight_button_down():
	randomize()
	var level = randi()%3+1
	match level:
		1:
			get_tree().change_scene("res://Scenes/Level1.tscn")
		2:
			get_tree().change_scene("res://Scenes/Level2.tscn")
		3:
			get_tree().change_scene("res://Scenes/Level3.tscn")

func shake_cam():
	$Camera2D.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amt, rand_range(-1.0, 1.0) * shake_amt))
func set_cam_back():
	$Camera2D.set_offset(Vector2.ZERO)
