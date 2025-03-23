extends Area2D

@onready var sfx = $AudioStreamPlayer2D
@onready var check_stack = $CheckStack
enum Day {ONE,TWO,THREE,FOUR,FIVE}
@export var day: Day
var areas_already_entered: Array
var successful_placement_sfx: AudioStream = load("res://Assets/Sound/UnpaidIntern_SFX_Trash.ogg")
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
		if area.get_parent().is_held == true:
			check_stack.start()
	elif area.is_in_group("Clutter"):
		var parent = area.get_parent()
		if parent.clutter_type == parent.ClutterType.WASTE:
			print("throwing away correct coffee cup")
			EventBus.succeeded_placement.emit()
			EventBus.bonus_objective.emit("Correct coffee cup thrown away")
		else:
			_failure_placement("Incorrect object discarded")
			parent.queue_free()
	
	
func _on_area_exited(area):
	if area.is_in_group("Item"):
		if area.get_parent().is_held == true:
			check_stack.stop()
		
#This function requires the day var to be set in the editor in order to match the correct expression
func check_area():
	var overlapping_areas = self.get_overlapping_areas()
	for area in overlapping_areas:
		if not area.is_in_group("Item") or area.get_parent().is_held or area in areas_already_entered:
			continue 
		
		areas_already_entered.append(area)
		var item = area.get_parent()
		match(day):
			Day.THREE:
				if item.text == "Gustav P.":
					_success_placement()
				else:
					_failure_placement("Incorrect file discarded")
				
		item.queue_free()


func _success_placement():
	print("Successful placement")
	EventBus.succeeded_placement.emit()
	check_stack.stop()
	sfx.stream = successful_placement_sfx
	sfx.play()


func _failure_placement(reason:String):
	print("Failed placement")
	EventBus.failed_placement.emit(reason)
	check_stack.stop()
	sfx.stream = unsuccessful_placement_sfx
	sfx.play()


func _on_check_stack_timeout():
	print("checking stack for folders to add")
	check_area()
