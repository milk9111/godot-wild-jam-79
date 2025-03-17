extends Node2D

signal timeout

const START_TIME := 9 * 60 * 60  # 9:00 AM in seconds
const END_TIME := 17 * 60 * 60   # 5:00 PM in seconds
const WORKDAY_DURATION := END_TIME - START_TIME  # Total workday duration in seconds

@onready var hour_label = %HourLabel
@onready var minute_label = %MinuteLabel
@onready var meridian_label = %MeridianLabel
@onready var timer = $Timer

var _is_ended
 

func convert_timer_to_clock(time_left):
	var elapsed_ratio = (timer.wait_time - time_left) / timer.wait_time
	var current_time = START_TIME + (WORKDAY_DURATION * elapsed_ratio)
	var hours = int(current_time / 3600.0) % 24
	var minutes = int((int(current_time) % 3600) / 60)
	return [hours if hours <= 12 else hours - 12, minutes, "AM" if hours < 12 else "PM"]


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
	var time_parts = convert_timer_to_clock(time_left)
	hour_label.text = "%d" % time_parts[0]
	minute_label.text = "%02d" % time_parts[1]
	meridian_label.text = "%s" % time_parts[2]


func _on_timer_timeout():
	_is_ended = true 
	timeout.emit()
