extends CharacterBody2D
class_name PlayerController

@export_category("Movement")
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var GRAVITY_MODIFIER = 1.0
@export var LAUNCH_VELOCITY = -1000.0
@export_category("Projectiles")
@export var PROJECTILE_SCENE : PackedScene

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right := true
var player_armed := false

### Event functions 
func _physics_process(delta):
	_actions()
	_movement(delta)

### Public functions
func launch():
	_jump(LAUNCH_VELOCITY)

### Private functions
func _actions():
	_check_armed()
	_check_shot()
	
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
		
func _check_shot():
	if player_armed && Input.is_action_just_pressed("shoot"):
		%View.projectile_shot()
		
		# Instantiate bullet
		var invert_multiplier := 1 if facing_right else -1
		var nuzzle_pos := (%View as PlayerView).nuzzle_pos()
		var nuzzle_pos_directed := Vector2(nuzzle_pos.x * invert_multiplier,nuzzle_pos.y)
		var nuzzle_pos_scaled := nuzzle_pos_directed*scale.x
		var nuzzle_global_pos := nuzzle_pos_scaled + global_position
		var bullet := PROJECTILE_SCENE.instantiate() as BulletController
		get_parent().add_child(bullet)
		bullet.position = nuzzle_global_pos
		bullet.scale *= invert_multiplier
		bullet.linear_velocity *= invert_multiplier
		
func _jump(jump_vel: float):
	velocity.y = jump_vel
	%View.jumped()
		
func _movement(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * GRAVITY_MODIFIER * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump(JUMP_VELOCITY)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	_check_direction(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	%View.animate(delta, velocity, is_on_floor())
