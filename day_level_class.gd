extends Node2D


class_name DayLevel

@onready var ambience = $Ambience
@onready var music = $Music
@onready var directions_splash = $DirectionsSplash
@onready var button = $DirectionsSplash/Button
@onready var active_folder = $SpawnManager/Spawn
@onready var directions = $Directions
@onready var animation_player = $AnimationPlayer

enum Day{ONE,TWO,THREE,FOUR,FIVE}
@export var day: Day
func _ready():
	ambience.play()
	music.play()
	active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	directions_splash.show()
	


func _on_directions_pressed():
	print("Button pressed")
	directions_splash.show()
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	active_folder.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_directions_closed():
	print("Button pressed")
	
	animation_player.play("Fade")
	await animation_player.animation_finished
	active_folder.process_mode = Node.PROCESS_MODE_INHERIT
	directions_splash.hide()


func _on_directions_mouse_entered():
	directions.material.set("shader_parameter/thickness",10.0)


func _on_directions_mouse_exited():
	directions.material.set("shader_parameter/thickness",0.0)
