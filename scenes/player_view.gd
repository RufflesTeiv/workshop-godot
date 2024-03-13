extends Node2D
class_name PlayerView

enum PlayerAnimation {IDLE, JUMP, WALKING}
var shown_node : Node2D
var player_armed := false
var was_grounded := false

### Event functions

func _ready():
	shown_node = %IdleSprite
	%WalkSprite.autoplay = "default"

### Public functions

func animate(velocity : Vector2, grounded : bool):
	
	if !grounded:
		_show_sprite(PlayerAnimation.JUMP)
	else:
		if abs(velocity.x) > 0.01:
			_show_sprite(PlayerAnimation.WALKING, 0 if was_grounded else 1)
		else:
			_show_sprite(PlayerAnimation.IDLE)
			
	was_grounded = grounded
	
func invert_sprite():
	scale = Vector2(-1.0*scale.x, scale.y)
	
func set_sprite_armed(value: bool):
	player_armed = value
			
### Private functions
func _hide_player_sprites():
	for child in %PlayerSprites.get_children():
		child.visible = false
		
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
