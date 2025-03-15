extends Node2D

signal timeout

@onready var label = $Label
@onready var timer = $Timer

var _is_ended

func initialize():
	_update_time_left_to_live(timer.wait_time)


func start():
	_is_ended = false
	timer.start()
	initialize()


func _ready():
	_is_ended = true
	initialize()


func _process(_delta):
	if _is_ended:
		return 
	
	_update_time_left_to_live(timer.time_left)


func _update_time_left_to_live(time_left):
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60 
	label.text = "%02d:%02d" % [minute, second]


func _on_timer_timeout():
	_is_ended = true 
	timeout.emit()
