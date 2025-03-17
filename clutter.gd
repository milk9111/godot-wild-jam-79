extends RigidBody2D

@onready var sfx = $SFX
@onready var sfx_timer = $SFXTimer
@onready var animation_player = $AnimationPlayer

@export var sfx_moved: AudioStreamRandomizer

var sound_playing:bool = false
		
func _ready():
	contact_monitor = true
	sfx.stream = sfx_moved
	lock_rotation = true
	
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
	


func _on_detect_area_area_entered(area):
	if area.is_in_group("TableLeft"):
		animation_player.play("TableLeft")
		await animation_player.animation_finished
		queue_free()
	if area.is_in_group("TableRight"):
		animation_player.play("TableRight")
		await animation_player.animation_finished
		queue_free()
	if area.is_in_group("TableBottom"):
		animation_player.play("TableDown")
		await animation_player.animation_finished
		queue_free()
	if area.is_in_group("TableTop"):
		animation_player.play("TableUp")
		await animation_player.animation_finished
		queue_free()
