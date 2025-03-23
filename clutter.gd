extends RigidBody2D

@onready var sfx = $SFX
@onready var sfx_timer = $SFXTimer
@onready var animation_player = $AnimationPlayer
enum ClutterType{KEEP,WASTE}
signal discarding_complete
@export var clutter_type:ClutterType = ClutterType.KEEP
@export var sfx_moved: AudioStreamRandomizer
var slide_sfx = load("res://Assets/Sound/mug_tapped_and_slide.ogg")
var break_sfx = load("res://Assets/Sound/ESM_Builder_Game_Ceramic_Break_Large_3_Organic_Smash_Crash_Crumble_Drop_Splatter_Particle_Hit_Stab_Impact.ogg")
var sound_playing:bool = false
var current_position	
func _ready():
	contact_monitor = true
	lock_rotation = true
	current_position = global_position
func _process(delta):
	if current_position != global_position:
		play_sound()
	else:
		pass
	current_position = global_position
	
	
func play_sound():
	if sfx_timer.is_stopped():
		$SFX.play()
		sfx_timer.start()
	else:
		pass
	


func _on_sfx_timer_timeout():
	sound_playing = false
	if clutter_type == ClutterType.KEEP:
		print("object nudged!")
		EventBus.failed_placement.emit("Object on table moved")
		


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
	if area.is_in_group("Trash"):
		if animation_player.has_animation("Trash"):
			animation_player.play("Trash")
		else:
			animation_player.play("TableRight")
		await animation_player.animation_finished
		queue_free()
