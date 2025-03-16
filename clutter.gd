extends RigidBody2D

@onready var sfx = $SFX
@onready var sfx_timer = $SFXTimer

@export var sfx_moved: AudioStreamRandomizer

var sound_playing:bool = false
		
func _ready():
	contact_monitor = true
	sfx.stream = sfx_moved

func _process(delta):
	if !sound_playing and linear_velocity.length() > 1:
		play_sound()
	elif sound_playing and linear_velocity.length() > 1:
		pass
	
	
func play_sound():
	if sfx_timer.is_stopped():
		sound_playing=true
		sfx.play()
		sfx_timer.start()
		
	


func _on_sfx_timer_timeout():
	sound_playing = false
	print("object nudged!")
	EventBus.nudged_obstacle.emit()
