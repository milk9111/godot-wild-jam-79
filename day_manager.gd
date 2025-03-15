class_name DayManager
extends Node2D

signal day_started
signal day_ended
signal internship_ended

@export var days : Array[PackedScene]

@onready var clock = $Clock

var _current_day_index : int

func _ready():
	_current_day_index = 0

func _on_clock_timeout():
	end_day()

func start_day():
	clock.start()
	day_started.emit()

func end_day():
	_current_day_index += 1
	if _current_day_index < days.size():
		day_ended.emit()
	else: 
		internship_ended.emit()

func get_current_day_scene() -> PackedScene:
	if _current_day_index >= days.size():
		return null
	
	return days[_current_day_index]
