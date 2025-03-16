extends Node2D

signal timeout

const START_TIME := 9 * 60 * 60  # 9:00 AM in seconds
const END_TIME := 17 * 60 * 60   # 5:00 PM in seconds
const WORKDAY_DURATION := END_TIME - START_TIME  # Total workday duration in seconds


@onready var label = $Label
@onready var timer = $Timer

var _is_ended
 

func convert_timer_to_clock(timer: Timer) -> String:
	var elapsed_ratio := (timer.wait_time - timer.time_left) / timer.wait_time
	var current_time := START_TIME + (WORKDAY_DURATION * elapsed_ratio)
	var hours := int(current_time / 3600.0) % 24
	var minutes := int((int(current_time) % 3600) / 60)
	return "%d:%02d %s" % [hours if hours <= 12 else hours - 12, minutes, "AM" if hours < 12 else "PM"]


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
	
	label.text = convert_timer_to_clock(timer)


func _on_timer_timeout():
	_is_ended = true 
	timeout.emit()
