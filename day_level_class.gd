extends Node2D


class_name DayLevel

@onready var ambience = $Ambience
@onready var music = $Music
@onready var directions_splash = $DirectionsSplash
@onready var button = $DirectionsSplash/Button
@onready var active_folder = $SpawnManager/Spawn

func _ready():
	ambience.play()
	
	music.play()

	


func _on_directions_pressed():
	print("Button pressed")
	active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	directions_splash.show()

func _on_directions_closed():
	print("Button pressed")
	active_folder.process_mode = Node.PROCESS_MODE_INHERIT
	directions_splash.hide()
