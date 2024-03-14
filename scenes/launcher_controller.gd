extends Area2D

### Event functions
func _ready():
	body_entered.connect(_launch_body)
	
### Private functions
func _launch_body(body: Node2D):
	if body.has_method("launch"):
		body.launch()
