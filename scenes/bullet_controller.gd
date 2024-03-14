extends RigidBody2D
class_name BulletController

### Event functions
func _ready():
	body_entered.connect(func(body): queue_free())
