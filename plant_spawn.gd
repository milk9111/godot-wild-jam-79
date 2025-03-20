extends Node2D

const PLANT = preload("res://plant.tscn")
@onready var spawn_locations = $SpawnLocations
@onready var spawns_array = $SpawnLocations.get_children()
@onready var timer = $Timer

func _ready():
	timer.start()
func _on_timer_timeout():
	for spawns in spawns_array:
		if spawns.get_children().size() == 0:
			var plant = PLANT.instantiate()
			plant.clutter_type = plant.ClutterType.WASTE
			spawns.add_child(plant)
			return
		else:
			print("no valid plant spawns found")
			pass
