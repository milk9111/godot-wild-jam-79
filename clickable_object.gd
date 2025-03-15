extends CharacterBody2D
class_name ClickableObject


const CLICK_THRESHOLD: float = 20.0
const SPEED: float = 1
enum State {SPAWNED,CLICKED,DROPPED,STACKED}

var state:State = State.SPAWNED

var move_tween:Tween
var final_pos: Vector2
var target_pos:Vector2
func _physics_process(delta):
	
	match state:
		0:
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_pressed("select"):
				if position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
		1:
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_pressed("select"):
				final_pos = position 
				state = State.DROPPED
			move()
		
		2:
			if Input.is_action_just_pressed("select"):
				if position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
			target_pos = final_pos
			move()
		3:
			pass
			

		
func move():
	move_tween = create_tween()
	move_tween.tween_property(self, "position", target_pos, SPEED)
	


func _on_detect_area_area_entered(area):
	if area.is_in_group("Stack"):
		var new_parent = area.get_child(2)
		state = State.STACKED
		call_deferred("set_process_mode",ProcessMode.PROCESS_MODE_DISABLED)
		call_deferred("reparent",new_parent)
		position = new_parent.global_position

	
