extends CanvasLayer

signal muted
signal unmuted
signal continued
signal exited


func _ready():
	visible = false 


func show_menu():
	visible = not visible 


func _on_mute_check_button_toggled(toggled_on):
	if toggled_on:
		muted.emit()
	else:
		unmuted.emit()


func _on_continue_button_pressed():
	visible = false
	continued.emit()


func _on_exit_button_pressed():
	visible = false
	exited.emit()
