extends CharacterBody2D
class_name PlayerController

@export_category("Movement")
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var GRAVITY_MODIFIER = 1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right := true
var player_armed := false

### Event functions 
func _physics_process(delta):
	_check_armed()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * GRAVITY_MODIFIER * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	_check_direction(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	%View.animate(velocity, is_on_floor())

### Private functions
func _check_armed():
	if Input.is_action_just_pressed("arm_up"):
		player_armed = true
		
	%View.set_sprite_armed(player_armed)

func _check_direction(direction : float):
	var left_to_right := direction > 0 && !facing_right
	var right_to_left := direction < 0 && facing_right
	var direction_changed := left_to_right || right_to_left
	
	if left_to_right:
		facing_right = true
	elif right_to_left:
		facing_right = false
	
	if direction_changed:
		%View.invert_sprite()
