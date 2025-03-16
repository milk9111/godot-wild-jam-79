extends Node2D


class_name DayLevel

const CLICKABLE_FOLDER = preload("res://clickable_folder.tscn")
@onready var ambience = $Ambience
@onready var music = $Music
@onready var spawn_timer = $SpawnTimer
@onready var spawn_points: Array = $Spawns.get_children()

func _ready():
	ambience.play()
	spawn_timer.start()
	spawn_object()


func _on_spawn_timer_timeout():
	spawn_object()

func spawn_object():
	var spawn_point = spawn_points.pick_random()
	var spawn_point_children_array = spawn_point.get_children()
	var object_spawn = CLICKABLE_FOLDER.instantiate()
	if spawn_point_children_array.size() == 2 :
		spawn_point.add_child(object_spawn)
		object_spawn.position = Vector2(-30,0)
	elif spawn_point_children_array.size() == 3 :
		spawn_point.add_child(object_spawn)
		object_spawn.position = Vector2(-60,0)
	else:
		spawn_point.add_child(object_spawn)
