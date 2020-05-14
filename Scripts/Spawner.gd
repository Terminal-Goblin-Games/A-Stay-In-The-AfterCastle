extends Area2D

var ghost = preload("res://Scenes/Ghost.tscn")
var barrel = preload("res://Scenes/Barrel.tscn")
var can_spawn = true
# Called when the node enters the scene tree for the first time.
func _ready():
	check_if_can_spawn()
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_can_spawn()
	spawn()

func spawn():
	if can_spawn:
		randomize()
		var chance = randi()%100+1
		
		if chance > 50:
			var bar = barrel.instance()
			get_parent().add_child(bar)
			bar.position.x = position.x + lerp(-50, 50, randf())
			bar.position.y = position.y + lerp(-50, 50, randf())
		else:
			var gho = ghost.instance()
			get_parent().add_child(gho)
			gho.position.x = position.x + lerp(-50, 50, randf())
			gho.position.y = position.y + lerp(-50, 50, randf())
	else:
		pass

# Quick and dirty function to see if the spawner can run
# Currently it will only spawn a max of 30 children
func check_if_can_spawn():
	if get_parent().get_child_count() > 30:
		can_spawn = false
	else:
		can_spawn = true

# Player being in the spawn area was causing issues. So we no longer let it spawn when the players inside
func _on_Spawner_body_entered(body):
	if body.get_name() == "Player":
		can_spawn = false

# Since we want that spawner to keep working after the player leaves we needed to reset the flag to true on player exit
func _on_Spawner_body_exited(body):
	if body.get_name() == "Player":
		can_spawn = true
