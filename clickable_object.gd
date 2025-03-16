extends CharacterBody2D
class_name ClickableObject


const CLICK_THRESHOLD: float = 10.0
const TWEEN_THRESHOLD: float = 30.0
const SPEED: float = .25
const MOVE_SPEED: float = 300.0

enum State {SPAWNED,CLICKED,DROPPED,STACKED}
enum Colors {BLUE,RED,YELLOW}
var color: Colors:
	set(new_color):
		match(new_color):
			Colors.BLUE:
				set_modulate(Color.BLUE)
			Colors.RED:
				set_modulate(Color.RED)
			Colors.YELLOW: 
				set_modulate(Color.YELLOW)
		color = new_color
	get():
		return color
@onready var sfx = $SFX
@onready var detect_area = $DetectArea

var select_sfx: AudioStreamRandomizer = load("res://Resources/select_sfx.tres")
var drop_sfx: AudioStreamRandomizer = load("res://Resources/drop_sfx.tres")
var state:State = State.SPAWNED
var stack_entered:bool = false
var move_tween:Tween
var final_pos: Vector2
var target_pos:Vector2
var rng = RandomNumberGenerator.new()
func _ready():
	color = rng.randi_range(0, 2)
func _physics_process(delta):
	
	match state:
		0:
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_pressed("select"):
				if global_position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
		1:
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_pressed("select"):
				final_pos = global_position 
				state = State.DROPPED
			move(delta)
		
		2:
			if Input.is_action_just_pressed("select"):
				target_pos = get_global_mouse_position() 
				if global_position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
			target_pos = final_pos
			move(delta)
		3:
			pass
			

		
func move(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	if global_position.distance_to(target_pos) > TWEEN_THRESHOLD:
		move_tween = create_tween()
		var target_velocity = direction * MOVE_SPEED
		move_tween.tween_property(self, "velocity", target_velocity, SPEED)
	elif global_position.distance_to(target_pos) < TWEEN_THRESHOLD and global_position.distance_to(target_pos) > CLICK_THRESHOLD:
		velocity = direction * MOVE_SPEED
	elif global_position.distance_to(target_pos) < CLICK_THRESHOLD:
		velocity = Vector2.ZERO
	move_and_slide()
	

func _input(event):
	if state == State.SPAWNED or state == State.DROPPED:
		target_pos = get_global_mouse_position() 
		if global_position.distance_to(target_pos) < CLICK_THRESHOLD:
			if event.is_action_pressed("select"):
				sfx.stream = select_sfx
				sfx.play()
	#if state == State.CLICKED:
		#
		#if event.is_action_pressed("select"):
			#sfx.stream = drop_sfx
			#sfx.play()
		
func _on_detect_area_area_entered(area):
	if area.is_in_group("Stack"):
			var new_parent = area.get_child(2)
			state = State.STACKED
			call_deferred("set_process_mode",ProcessMode.PROCESS_MODE_DISABLED)
			call_deferred("reparent",new_parent)
			global_position = new_parent.global_position

	
