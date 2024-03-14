extends Node2D
class_name BaseSceneController

@export var SLIDE_TRANSITION := 1.0
@export var MAX_SLIDES := 30

var next_slide_idx : int = 0
var slides : Array[Node] = []

### Event functions
func _ready():
	for trigger in %CameraTriggers.get_children():
		trigger.on_camera_triggered.connect(_switch_camera_position)
	slides = %Slides.get_children()
	for i in range(slides.size()):
		_hide_slide(i,true)
	_switch_camera_position(0,true)
	
func _process(delta):
	_check_slide_input()
		
### Private functions
func _check_slide_input():
	if Input.is_action_just_pressed("next_slide") && next_slide_idx < slides.size():
		_show_slide(next_slide_idx)
		if (next_slide_idx >= MAX_SLIDES):
			_hide_slide(next_slide_idx-MAX_SLIDES)
		next_slide_idx += 1
	elif Input.is_action_just_pressed("last_slide") && next_slide_idx > 0:
		_hide_slide(next_slide_idx-1)
		next_slide_idx -= 1
		
func _hide_slide(slide_idx: int, instant := false):
	var tween := create_tween()
	tween.tween_property(slides[slide_idx],"modulate",Color(1,1,1,0),SLIDE_TRANSITION if !instant else 0)
	tween.tween_callback(func(): slides[slide_idx].visible = false)
		
func _show_slide(slide_idx: int, instant := false):
	slides[slide_idx].visible = true
	var tween := create_tween()
	tween.tween_property(slides[slide_idx],"modulate",Color(1,1,1,1),SLIDE_TRANSITION if !instant else 0)
	
	
func _switch_camera_position(point_idx : int, instant := false):
	var camera_point := %CameraPoints.get_children()[point_idx] as Node2D
	var new_position := camera_point.global_position
	var camera_tween := create_tween()
	camera_tween.tween_property(%Camera, "position", new_position, 1 if !instant else 0)
