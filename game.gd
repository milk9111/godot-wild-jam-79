extends Node

@onready var day_manager : DayManager = $DayManager
@onready var day_holder : Node = $DayHolder
@onready var day_transition = $DayTransition
@onready var score_manager = $ScoreManager
@onready var performance_review = $PerformanceReview

var _reached_end_of_internship

func _ready():
	_reached_end_of_internship = false
	_load_next_day()


func _process(_delta):
	if not Global.debug:
		return 
	
	if Input.is_action_just_pressed("debug_end_day"):
		day_manager.end_day()
	if Input.is_action_just_pressed("debug_print_score"):
		print("success: %d - failed: %d - nudged: %d" % [score_manager._successful_placements, score_manager._failed_placements, score_manager._nudged_obstacles])


func _set_day_holder(day_scene : PackedScene):
	if day_scene == null:
		return 
	
	for child in day_holder.get_children():
		day_holder.remove_child(child)
	
	day_holder.add_child(day_scene.instantiate())


func _load_next_day():
	day_manager.clock.initialize()
	score_manager.initialize()
	_set_day_holder(day_manager.get_current_day_scene())
	day_transition.play("fade_out")
	get_tree().paused = false


func _unload_current_day():
	get_tree().paused = true
	day_transition.play("fade_in")


func _on_day_manager_day_ended():
	_unload_current_day()


func _on_day_manager_internship_ended():
	_reached_end_of_internship = true
	_unload_current_day()


func _on_day_transition_animation_finished(anim_name):
	match anim_name:
		"fade_out":
			day_manager.start_day()
		"fade_in":
			var score_report = score_manager.get_report()
			performance_review.show_report(score_report[0], score_report[1], score_report[2])


func _on_performance_review_accepted_review():
	if _reached_end_of_internship:
		get_tree().change_scene_to_file("res://credits.tscn")
	else:
		_load_next_day()
