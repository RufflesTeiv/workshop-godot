extends Area2D
class_name CameraTriggerController

@export var camera_point: int = 0

signal on_camera_triggered(camera_point)

### Event functions
func _ready():
	body_entered.connect(func(_body): on_camera_triggered.emit(camera_point))
