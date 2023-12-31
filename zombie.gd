extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed = 2
# Maximum speed of the mob in meters per second.
@export var max_speed = 5

var speed;

func _physics_process(_delta):
	move_and_slide()

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We calculate a random speed (integer)
	speed = randi_range(min_speed, max_speed)
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	
func chase_player(player_position):
	look_at(player_position, Vector3.UP)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
