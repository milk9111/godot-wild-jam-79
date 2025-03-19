extends Area2D
class_name Stack

@onready var child_items_container = $Children
@onready var sfx = $AudioStreamPlayer2D
@onready var sprite = $Sprite2D
@onready var check_stack = $CheckStack
@onready var children = $Children
enum Day {ONE,TWO,THREE,FOUR,FIVE}
enum Colors {BLUE,RED,YELLOW}
@export var day: Day
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
		
#This function requires the day var to be set in the editor in order to match the correct expression
func check_area():
	var overlapping_areas = self.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent().is_held or not area.is_in_group("Item") or area in areas_already_entered:
			continue 
		
		areas_already_entered.append(area)
		var item = area.get_parent()
		match(day):
			Day.ONE:
				if item.color == stack_color:
					_success_placement()
				elif item.color != stack_color:
					_failure_placement("A file's color did not match the stack")
			Day.TWO:
				if item.text == "Mark S." and stack_color == Colors.RED: 
					_success_placement()
				elif item.text == "Mark S." and stack_color != Colors.RED: 
					_failure_placement("Mark S. file was placed incorrectly")
				elif item.color == stack_color and item.text != "Mark S.":
					_success_placement()
				elif item.color != stack_color and item.text != "Mark S.":
					_failure_placement("A file's color did not match the stack")
			Day.THREE:
				if item.text == "Mark S." and stack_color == Colors.RED: 
					_success_placement()
				elif item.text == "Mark S." and stack_color != Colors.RED: 
					_failure_placement("Mark S. file was placed incorrectly")
				elif item.text == "Gustav P.":
					_failure_placement("Gustav P. file was not thrown away")
				elif item.color == stack_color and item.text != "Mark S.":
					_success_placement()
				elif item.color != stack_color and item.text != "Mark S.":
					_failure_placement("A file's color did not match the stack")
		var parent = area.get_parent()
		parent.state = ClickableObject.State.STACKED
		parent.reparent(children)


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
