extends Node2D

class_name DayLevel

@onready var ambience = $Ambience
@onready var music = $Music


func _ready():
	ambience.play()
