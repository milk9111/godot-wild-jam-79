extends Node2D

const CLICKABLE_FOLDER = preload("res://clickable_folder.tscn")
@onready var spawn_timer = $SpawnTimer
@onready var queue = $Queue
@onready var spawn = $Spawn

func _ready():
	spawn_object()
	spawn_timer.start()
	
func _process(delta):
	if queue.get_children():
		if spawn.get_children().size() == 0:
			var node_to_add = queue_up()
			node_to_add.state = 0
			node_to_add.call_deferred("reparent",spawn)
			node_to_add.global_position = spawn.global_position
	
func _on_spawn_timer_timeout():
	spawn_object()

func spawn_object():
	var object_to_spawn = CLICKABLE_FOLDER.instantiate()
	object_to_spawn.state = 4
	queue.add_child(object_to_spawn)
	organize_queue()
func queue_up():
	var queued_scenes:Array = queue.get_children()
	var next_up = queued_scenes.pop_front()
	return next_up

func organize_queue():
	var shift_counter: Vector2 = Vector2(0,0)
	for item in queue.get_children():
		item.position = shift_counter
	for item in queue.get_children():
		item.position += shift_counter
		shift_counter+=Vector2(10,-5)
