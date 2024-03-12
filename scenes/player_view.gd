extends Node2D
class_name PlayerView

enum PlayerAnimation {IDLE, JUMP, WALKING}
var shown_node : Node2D

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
			_show_sprite(PlayerAnimation.WALKING)
		else:
			_show_sprite(PlayerAnimation.IDLE)
	
func invert_sprite():
	scale = Vector2(-1.0*scale.x, scale.y)
			
### Private functions
func _hide_children():
	for child in self.get_children():
		child.visible = false
func _show_sprite(animation : PlayerAnimation):
	var new_shown_node : Node2D
	
	match animation:
		PlayerAnimation.IDLE:
			new_shown_node = %IdleSprite
		PlayerAnimation.JUMP:
			new_shown_node = %JumpSprite
		PlayerAnimation.WALKING:
			new_shown_node = %WalkSprite
	
	if new_shown_node != shown_node:
		_hide_children()
		new_shown_node.visible = true
		if new_shown_node.has_method("play"):
			new_shown_node.play()
		
		shown_node = new_shown_node
