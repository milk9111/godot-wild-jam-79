extends Node2D


class_name DayLevel

@onready var ambience = $Ambience
@onready var music = $Music
@onready var directions_splash = $DirectionsSplash
@onready var button = $DirectionsSplash/Button
@onready var active_folder = $SpawnManager/Spawn
@onready var directions = $Directions

func _ready():
	ambience.play()
	music.play()
	active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	directions_splash.show()
	


func _on_directions_pressed():
	print("Button pressed")
	active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	directions_splash.show()

func _on_directions_closed():
	print("Button pressed")
	active_folder.process_mode = Node.PROCESS_MODE_INHERIT
	directions_splash.hide()


func _on_directions_mouse_entered():
	directions.material.set("shader_parameter/thickness",10.0)


func _on_directions_mouse_exited():
	directions.material.set("shader_parameter/thickness",0.0)
