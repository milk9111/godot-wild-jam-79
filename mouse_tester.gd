extends Area2D

var _is_mouse_hovering


func _process(_delta):
	position = get_viewport().get_mouse_position()
	
	if Global.debug:
		if Input.is_action_just_pressed("debug_successful_placement"):
			EventBus.succeeded_placement.emit()
		elif Input.is_action_just_pressed("debug_failed_placement"):
			EventBus.failed_placement.emit()
		elif Input.is_action_just_pressed("debug_nudged_obstacle"):
			EventBus.nudged_obstacle.emit()


func _on_day_manager_day_started():
	set_process_mode(ProcessMode.PROCESS_MODE_INHERIT)


func _on_day_manager_day_ended():
	set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
