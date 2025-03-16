extends Area2D
class_name Stack

@onready var child_items_container = $Children
@onready var sfx = $AudioStreamPlayer2D

@export var placement_sfx: AudioStreamRandomizer
@export var successful_placement_sfx: AudioStreamRandomizer
@export var unsuccessful_placement_sfx: AudioStreamRandomizer
var items_in_stack: Array:
	set(new_items_in_stack):
		if $Children.get_children():
			new_items_in_stack = $Children.get_children()
			items_in_stack = new_items_in_stack
		else:
			pass
	get():
		return items_in_stack
		



func _on_area_entered(area):
	if area.is_in_group("Item"):
		sfx.stream = placement_sfx
		sfx.play()
