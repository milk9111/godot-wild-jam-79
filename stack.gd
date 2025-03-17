extends Area2D
class_name Stack

@onready var child_items_container = $Children
@onready var sfx = $AudioStreamPlayer2D
@onready var sprite = $Sprite2D
@onready var check_stack = $CheckStack
@onready var children = $Children

enum Colors {BLUE,RED,YELLOW}
@export var stack_color: Colors:
	set(new_stack_color):
		stack_color = new_stack_color
	get():
		return stack_color
			
@export var placement_sfx: AudioStreamRandomizer
@export var texture: AtlasTexture
var areas_already_entered: Array
var successful_placement_sfx: AudioStream = load("res://Assets/Sound/UnpaidIntern_SetDown_SFX 2.ogg")
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
	sprite.texture = texture

func _on_area_entered(area):
	if area.get_parent() is not Marker2D:
		if area.get_parent().is_held == true:
			check_stack.start()
	#if area.get_parent().is_held == false:
		#if area.is_in_group("Item"):
			#if area not in areas_already_entered:
				#areas_already_entered.append(area)
				#if area.get_parent().color == stack_color:
					#print("Successful placement")
					#EventBus.succeeded_placement.emit()
					#sfx.stream = successful_placement_sfx
					#sfx.play()
				#elif area.get_parent().color != stack_color:
					#print("Failed placement")
					#EventBus.failed_placement.emit()
					#sfx.stream = unsuccessful_placement_sfx
					#sfx.play()
func _on_area_exited(area):
	if area.get_parent() is not Marker2D:
		if area.get_parent().is_held == true:
			check_stack.stop()
		
		
func check_area():
	var overlapping_areas = self.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is not Marker2D:
			if area.get_parent().is_held == false:
				if area.is_in_group("Item"):
					if area not in areas_already_entered:
						areas_already_entered.append(area)
						if area.get_parent().color == stack_color:
							print("Successful placement")
							EventBus.succeeded_placement.emit()
							check_stack.stop()
							sfx.stream = successful_placement_sfx
							sfx.play()
						elif area.get_parent().color != stack_color:
							print("Failed placement")
							EventBus.failed_placement.emit()
							check_stack.stop()
							sfx.stream = unsuccessful_placement_sfx
							sfx.play()
						var parent = area.get_parent()
						parent.state = 3
						parent.reparent(children)

		
		


func _on_check_stack_timeout():
	print("checking stack for folders to add")
	check_area()
