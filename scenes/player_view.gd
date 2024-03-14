extends Node2D
class_name PlayerView

@export_category("Nuzzle")
@export var BASE_NUZZLE_POSITION : Vector2 = Vector2(8,-5)
@export_category("Sounds")
@export var ARM_UP_SOUND : AudioStream
@export var JUMP_SOUND : AudioStream
@export var SHOOT_SOUND : AudioStream
@export var STEP_SOUND : AudioStream
@export var STEP_TIME : float = 0.4

enum PlayerAnimation {IDLE, JUMP, WALKING}
var shown_node : Node2D
var player_armed := false
var was_grounded := false
var last_velocity : float = 0.0
var step_count : float

### Event functions

func _ready():
	shown_node = %IdleSprite
	step_count = STEP_TIME

### Public functions

func animate(delta : float, velocity : Vector2, grounded : bool):
	var just_grounded = grounded && !was_grounded
	var just_moved = (abs(velocity.x) > 0.01 && !(abs(last_velocity) > 0.01)) && grounded
	
	if !grounded:
		_show_sprite(PlayerAnimation.JUMP)
	else:
		if abs(velocity.x) > 0.01:
			_show_sprite(PlayerAnimation.WALKING, 1 if just_grounded else 0)
			step_count -= delta
		else:
			_show_sprite(PlayerAnimation.IDLE)
			
	if !player_armed:
		_check_step_sound(just_grounded || just_moved)
	last_velocity = velocity.x
	was_grounded = grounded
	
func invert_sprite():
	scale = Vector2(-1.0*scale.x, scale.y)
	
func jumped():
	AudioManager.play_audio(JUMP_SOUND)

func projectile_shot():
	# Audio
	AudioManager.play_audio(SHOOT_SOUND)
	
	# Visual
	%NuzzleFlashSprite.position = nuzzle_pos()
	%NuzzleFlashSprite.visible = true
	TimeManager.call_delayed(func(): %NuzzleFlashSprite.visible = false, 0.1)
	
func nuzzle_pos() -> Vector2:
	# Y Position
	var y_pos := BASE_NUZZLE_POSITION.y
	match shown_node.name:
		"JumpGunSprite":
			y_pos -= 1
		"WalkGunSprite":
			y_pos -= 1-%WalkGunSprite.frame
	return Vector2(BASE_NUZZLE_POSITION.x,y_pos)
	
func set_sprite_armed(value: bool):
	if !player_armed and value:
		AudioManager.play_audio(ARM_UP_SOUND)
		
	player_armed = value
			
### Private functions
func _check_step_sound(play_now: bool):
	if step_count <= 0.0 || play_now:
		AudioManager.play_audio(STEP_SOUND, -10.0)
		step_count = STEP_TIME
	
	
func _hide_player_sprites():
	for child in %PlayerSprites.get_children():
		child.visible = false
		
func _show_sprite(animation : PlayerAnimation, from_frame : int = 0):
	var new_shown_node : Node2D
	
	match animation:
		PlayerAnimation.IDLE:
			new_shown_node = %IdleGunSprite if player_armed else %IdleSprite
		PlayerAnimation.JUMP:
			new_shown_node = %JumpGunSprite if player_armed else %JumpSprite
		PlayerAnimation.WALKING:
			new_shown_node = %WalkGunSprite if player_armed else %WalkSprite
	
	if new_shown_node != shown_node:
		_hide_player_sprites()
		new_shown_node.visible = true
		_transpose_animation(shown_node,new_shown_node,from_frame)
		
		shown_node = new_shown_node
		
func _transpose_animation(old_node: Node2D, new_node: Node2D, from_frame : int = 0):
	if !new_node.has_method("play"):
		return
	
	var current_frame : int
	var current_progress : float
	if old_node.has_method("play"):
		current_frame = old_node.get_frame()
		current_progress = old_node.get_frame_progress()
	else:
		current_frame = from_frame
		current_progress = 0.0
	new_node.play()
	new_node.set_frame_and_progress(current_frame, current_progress)
