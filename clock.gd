extends Node2D

signal timeout

@onready var label = $Label
@onready var timer = $Timer

func start():
	timer.start()

func _process(delta):
	label.text = "%02d:%02d" % _time_left_to_live()

func _time_left_to_live():
	var time_left = timer.time_left 
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60 
	return [minute, second]

func _on_timer_timeout():
	timeout.emit()
