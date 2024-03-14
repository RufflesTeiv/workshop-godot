extends RigidBody2D

@export var MAX_HEALTH := 10
@export var HIT_SOUND : AudioStream
@export var DEATH_SOUND : AudioStream

var health : int

### Event functions
func _ready():
	health = MAX_HEALTH

func _process(delta):
	body_entered.connect(_take_hit)
	
### Private functions
func _fucking_move():
	freeze = false
	contact_monitor = false
	angular_velocity = 100.0
#	TimeManager.call_delayed(queue_free,1.0)

func _fucking_die():
	AudioManager.play_audio(DEATH_SOUND)
	call_deferred("_fucking_move")

func _take_hit(_body: Node):
	health -= 1
	
	var tween = create_tween()
	tween.tween_property(%QRCodeSprite, "modulate", Color(1,0,0), 0.1)
	tween.tween_property(%QRCodeSprite, "modulate", Color(1,1,1), 0.1)
	
	if health <= 0:
		_fucking_die()
	else:
		AudioManager.play_audio(HIT_SOUND)
		
