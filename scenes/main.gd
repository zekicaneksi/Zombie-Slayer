extends Node

var mob_scene = preload("res://scenes/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$PauseInterface.hide()
	$PauseInterface/RestartButton.hide()
	$PauseInterface/DeathLabel.hide()

func pause_game():
	get_tree().paused = true
	$PauseInterface.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func continue_game():
	get_tree().paused = false
	$PauseInterface.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_touched_player():
	get_tree().paused = true
	$PauseInterface.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$PauseInterface/ContinueButton.hide()
	$PauseInterface/RestartButton.show()
	$PauseInterface/DeathLabel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("escape"):
		pause_game()
	
	for zombie in get_tree().get_nodes_in_group("zombies"):
		zombie.chase_player($Player.position)


func _on_mob_spawn_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("MobSpawnPath/MobSpawnLocation")
	var player_position = $Player.position
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	# If it is too close to the player, get random one again
	while mob_spawn_location.position.distance_to($Player.position) <= 15.0:
		mob_spawn_location.progress_ratio = randf()

	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	mob.killed.connect($UserInterface/ScoreLabel._on_zombie_killed.bind())
	mob.touched_player.connect(_on_touched_player)
