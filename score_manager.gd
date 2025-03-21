extends Node2D


var _successful_placements : int
var _failed_placements : int
var _nudged_obstacles : int
var _failure_reasons:PackedStringArray
var _bonus:PackedStringArray

func _ready():
	EventBus.succeeded_placement.connect(self._on_event_bus_successful_placement)
	EventBus.failed_placement.connect(self._on_event_bus_failed_placement)
	EventBus.nudged_obstacle.connect(self._on_event_bus_nudged_obstacle)
	EventBus.bonus_objective.connect(self._on_bonus_objective)
	initialize()


func _process(_delta):
	if Global.debug:
		if Input.is_action_just_pressed("debug_successful_placement"):
			EventBus.succeeded_placement.emit()
		elif Input.is_action_just_pressed("debug_failed_placement"):
			EventBus.failed_placement.emit()
		elif Input.is_action_just_pressed("debug_nudged_obstacle"):
			EventBus.nudged_obstacle.emit()


func initialize():
	print("initializing score vars")
	_successful_placements = 0
	_failed_placements = 0
	_nudged_obstacles = 0 
	_failure_reasons = []
	_bonus = []

func get_report():
	return [_successful_placements, _failed_placements,_failure_reasons,_bonus]


func _on_event_bus_successful_placement():
	_successful_placements += 1


func _on_event_bus_failed_placement(reason:String):
	_failed_placements += 1
	_failure_reasons.append(reason)

func _on_event_bus_nudged_obstacle():
	_nudged_obstacles += 1

func _on_bonus_objective(bonus):
	_bonus.append(bonus)
