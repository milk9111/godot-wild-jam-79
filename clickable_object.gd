extends CharacterBody2D
class_name ClickableObject


const CLICK_THRESHOLD: float = 60.0
const LERP_THRESHOLD: float = 30.0
const SPEED: float = .05
const ACCELERATION:float = 500.0
const MOVE_SPEED: float = 500.0
const SMOOTHING_FACTOR:float = 1
enum State {SPAWNED,CLICKED,DROPPED,STACKED,QUEUED}
enum Colors {BLUE,RED,YELLOW}
enum Day {ONE,TWO,THREE,FOUR,FIVE}
var color: Colors:
	set(new_color):
		match(new_color):
			Colors.BLUE:
				sprite_2d.texture = blue_texture
			Colors.RED:
				sprite_2d.texture = red_texture
			Colors.YELLOW: 
				sprite_2d.texture = yellow_texture
		color = new_color
	get():
		return color
@onready var sfx = $SFX
@onready var detect_area = $DetectArea
@onready var sprite_2d = $Sprite2D
@onready var label = $Label

@export var blue_texture:AtlasTexture
@export var red_texture:AtlasTexture
@export var yellow_texture:AtlasTexture
var name_strings: Array = ["Mark S.","Barbara H.","Mike W.","Gustav P."]
var select_sfx: AudioStreamRandomizer = load("res://Resources/select_sfx.tres")
var drop_sfx: AudioStreamRandomizer = load("res://Resources/drop_sfx.tres")
var state:State = State.SPAWNED
var stack_entered:bool = false
var move_tween:Tween
var final_pos: Vector2
var target_pos:Vector2
var is_held: bool = false
var rng = RandomNumberGenerator.new()
var text:String:
	set(new_text):
		$Label.text = new_text
		text = new_text
	get():
		return text
var day:Day:
	set(new_day):
		match(new_day):
			0:
				pass
			1: 
				text = name_strings.pick_random()
		day = new_day
	get():
		return day
func _ready():
	color = rng.randi_range(0, 2)
	$Sprite2D.material.set("shader_parameter/thickness",0.0)
func _physics_process(delta):
	
	match state:
		0:
			is_held = false
			set_shader()
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_pressed("select"):
				if global_position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
			
		1:	
			is_held = true
			z_index = 1
			target_pos = get_global_mouse_position() 
			if Input.is_action_just_released("select"):
				final_pos = global_position 
				state = State.DROPPED
			move(delta)
		
		2:
			is_held = false
			if Input.is_action_just_pressed("select"):
				target_pos = get_global_mouse_position() 
				if global_position.distance_to(target_pos) < CLICK_THRESHOLD:
					state = State.CLICKED
			target_pos = final_pos
			set_shader()
			#move(delta)
		3:
			is_held = false
			z_index = 0
			detect_area.monitorable = false
			set_shader()
		4:
			pass
			

func set_shader():
	if state == State.SPAWNED or state == State.DROPPED:
		if global_position.distance_to(get_viewport().get_mouse_position()) < CLICK_THRESHOLD:
			$Sprite2D.material.set("shader_parameter/thickness",3.0)
		else:
			$Sprite2D.material.set("shader_parameter/thickness",0.0)
	else:
		$Sprite2D.material.set("shader_parameter/thickness",0.0)
	
func move(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	velocity += direction * ACCELERATION
	
	if velocity.length() > MOVE_SPEED:
		velocity = velocity.normalized() * MOVE_SPEED
		
	if (mouse_position - global_position).length() < LERP_THRESHOLD and (mouse_position - global_position).length() >= 10:
			#velocity = Vector2.ZERO
			velocity = lerp(velocity, Vector2.ZERO, SMOOTHING_FACTOR)
	if (mouse_position - global_position).length() < 10:
			velocity = Vector2.ZERO
			#velocity = lerp(velocity, Vector2.ZERO, SMOOTHING_FACTOR)
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
	pass
	#if is_held == false:
		#if area.is_in_group("Stack"):
				#var new_parent = area.get_child(2)
				#state = State.STACKED
				#call_deferred("set_process_mode",ProcessMode.PROCESS_MODE_DISABLED)
				#call_deferred("reparent",new_parent)
				#global_position = new_parent.global_position

	
