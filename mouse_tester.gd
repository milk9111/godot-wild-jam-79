extends Area2D

var _is_mouse_hovering


func _process(_delta):
	position = get_viewport().get_mouse_position()


func _on_day_manager_day_started():
	set_process_mode(ProcessMode.PROCESS_MODE_INHERIT)


func _on_day_manager_day_ended():
	set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
