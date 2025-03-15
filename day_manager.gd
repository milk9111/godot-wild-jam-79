extends Node2D

signal day_started
signal day_ended

@onready var clock = $Clock

func _ready():
	_start_day()

func _on_clock_timeout():
	_end_day()

func _start_day():
	clock.start()
	day_started.emit()

func _end_day():
	day_ended.emit()
