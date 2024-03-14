@tool
extends Marker2D
class_name CameraPointController

### Event functions
func _draw():
	if Engine.is_editor_hint():
		var width = 3456
		var height = 2160 
		draw_rect(Rect2(-width/2,-height/2,width,height),Color.MAGENTA,false)
