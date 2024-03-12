extends Node

### Event functions
func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
