extends Node2D


class_name DayLevel

@onready var ambience = $Ambience
@onready var music = $Music
@onready var directions_splash = $DirectionsSplash

@onready var active_folder = $SpawnManager/Spawn
@onready var directions = $Directions


@export var unredactor_node:Node2D

var notepad_down = load("res://Assets/Sound/UnpaidIntern_SFX_NotepadDown.ogg")
var notepad_up = load("res://Assets/Sound/UnpaidIntern_SFX_NotepadUp.ogg")
enum Day{ONE,TWO,THREE,FOUR,FIVE}
@export var day: Day
func _ready():
	ambience.play()
	music.play()
	EventBus.started_day.connect(_on_started_day)
	directions_splash.fade_in_finished.connect(_on_fade_in_finished)
	directions_splash.fade_out_finished.connect(_on_fade_out_finished)
func _on_started_day():
	#active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	directions_splash.show()
	get_tree().paused = true


func _on_directions_pressed():
	
	print("Button pressed")
	directions_splash.show()
	directions_splash.fade_in()
	await directions_splash.fade_in_finished
	get_tree().paused = true
	#active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_directions_closed():
	print("Button pressed")
	
	directions_splash.fade_out()
	await directions_splash.fade_out_finished
	get_tree().paused = false
	active_folder.process_mode = Node.PROCESS_MODE_INHERIT
	directions_splash.hide()

func _on_directions_mouse_entered():
	directions.material.set("shader_parameter/thickness",10.0)


func _on_directions_mouse_exited():
	directions.material.set("shader_parameter/thickness",0.0)


func _on_fade_in_finished():
	pass
func _on_fade_out_finished():
	pass
