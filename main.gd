extends Node

var mob_scene = preload("res://zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
