extends Node2D

const CLICKABLE_FOLDER = preload("res://clickable_folder.tscn")
@onready var spawn_timer = $SpawnTimer
@onready var queue = $Queue
@onready var spawn = $Spawn
@onready var spawn_special = $SpawnSpecial

enum Day{ONE,TWO,THREE,FOUR,FIVE}
@export var day: Day
var _rng : RandomNumberGenerator

func _ready():
	_rng = RandomNumberGenerator.new()
	if day == Day.FOUR:
		spawn_object(true)
		spawn_special.start()
	else: 
		spawn_object(false)
	spawn_timer.start()
	
func _process(delta):
	if queue.get_children():
		if spawn.get_children().size() == 0 or (spawn.get_children().size() == 1 and spawn.get_child(0).currently_unredacting == true):
			var node_to_add = queue_up()
			node_to_add.state = 0
			node_to_add.call_deferred("reparent",spawn)
			node_to_add.global_position = spawn.global_position
	
func _on_spawn_timer_timeout():
	spawn_object(false)

func spawn_object(special:bool):
	var object_to_spawn = CLICKABLE_FOLDER.instantiate()
	object_to_spawn.state = ClickableObject.State.QUEUED
	match (day):
		0:
			object_to_spawn.day = 0
		1:
			object_to_spawn.day = 1
		2:
			object_to_spawn.day = 2
		3:
			object_to_spawn.day = 3
		4:
			object_to_spawn.day = 4
	queue.add_child(object_to_spawn)
	object_to_spawn.position += Vector2(_rng.randf_range(-4, 4), _rng.randf_range(-4, 4))
	object_to_spawn.rotate(_rng.randf_range(-0.1, 0.1))
	if special == true:
		print("Spawning redacted folder!")
		object_to_spawn.redacted = true
	#organize_queue()
func queue_up():
	var queued_scenes:Array = queue.get_children()
	var next_up = queued_scenes.pop_front()
	return next_up

func organize_queue():
	var shift_counter: Vector2 = Vector2(0,0)
	for item in queue.get_children():
		item.position = shift_counter
	for item : Node2D in queue.get_children():
		item.position += shift_counter
		item.rotate(_rng.randf_range(-0.1, 0.1))
		shift_counter+=Vector2(_rng.randf_range(-4, 4), _rng.randf_range(-4, 4))


func _on_spawn_special_timeout():
	spawn_object(true)
