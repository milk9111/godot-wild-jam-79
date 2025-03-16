extends Area2D
class_name Stack

@onready var child_items_container = $Children
@onready var sfx = $AudioStreamPlayer2D
@onready var sprite = $Sprite2D

enum Colors {BLUE,RED,YELLOW}
@export var stack_color: Colors:
	set(new_stack_color):
		match(new_stack_color):
			Colors.BLUE:
				set_modulate(Color.BLUE)
			Colors.RED:
				set_modulate(Color.RED)
			Colors.YELLOW: 
				set_modulate(Color.YELLOW)
		stack_color = new_stack_color
	get():
		return stack_color
			
@export var placement_sfx: AudioStreamRandomizer
var areas_already_entered: Array
var successful_placement_sfx: AudioStream = load("res://Assets/Sound/MOST_SFX_AscendingKeys.ogg")
var unsuccessful_placement_sfx: AudioStream = load("res://Assets/Sound/MOST_SFX_BadKeys.ogg")
var items_in_stack: Array:
	set(new_items_in_stack):
		if $Children.get_children():
			new_items_in_stack = $Children.get_children()
			items_in_stack = new_items_in_stack
		else:
			pass
	get():
		return items_in_stack
		

func _ready():
	pass

func _on_area_entered(area):
	if area.is_in_group("Item"):
		if area not in areas_already_entered:
			areas_already_entered.append(area)
			if area.get_parent().color == stack_color:
				print("Successful placement")
				EventBus.succeeded_placement.emit()
				sfx.stream = successful_placement_sfx
				sfx.play()
			elif area.get_parent().color != stack_color:
				print("Failed placement")
				EventBus.failed_placement.emit()
				sfx.stream = unsuccessful_placement_sfx
				sfx.play()
