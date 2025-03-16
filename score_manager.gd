extends Node2D


var _successful_placements : int
var _failed_placements : int
var _nudged_obstacles : int


func _ready():
	EventBus.succeeded_placement.connect(self._on_event_bus_successful_placement)
	EventBus.failed_placement.connect(self._on_event_bus_failed_placement)
	EventBus.nudged_obstacle.connect(self._on_event_bus_nudged_obstacle)
	initialize()


func initialize():
	_successful_placements = 0
	_failed_placements = 0
	_nudged_obstacles = 0 


func _on_event_bus_successful_placement():
	_successful_placements += 1


func _on_event_bus_failed_placement():
	_failed_placements += 1


func _on_event_bus_nudged_obstacle():
	_nudged_obstacles += 1
