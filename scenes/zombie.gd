extends CharacterBody3D

signal killed
signal touched_player

# Minimum speed of the mob in meters per second.
@export var min_speed = 1
# Maximum speed of the mob in meters per second.
@export var max_speed = 3

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

func hit():
	killed.emit()
	queue_free()


func _on_front_stick_body_entered(body):
	if body.is_in_group("player"):
		touched_player.emit()
