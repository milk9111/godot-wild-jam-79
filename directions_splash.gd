extends CanvasLayer
@onready var animation_player = $AnimationPlayer
@onready var sfx = $sfx
@onready var label = $Control/Label
@onready var label_2 = $Control/Label2
@onready var texture_rect_2 = $Control/TextureRect2

signal fade_in_finished
signal fade_out_finished
signal button_pressed
enum Day {ONE,TWO,THREE,FOUR,FIVE}
@export var day: Day
var day_one_instructions:String = "Intern,
[ul] Place red files in the red stack.
Place blue files in blue stack.
Place yellow files in the yellow  stack."
var day_two_instructions:String = "If you get a file from Mark S., put it in the red stack.
Don't touch my fresh, daily latte's."
var day_three_instructions:String = "Throw away the files for Gustav P. who has been terminated.
My wife got me a succulent for my work anniversary. DON’T TOUCH
Oh, and do something with yesterday's latte, each day. It's unsanitary for you to leave them."
var day_four_instructions:String = "[ul]Some of the files will need to be unredacted on The Unredactor. Don't let them sit for too long."
var day_five_instructions:String = "An order has come in from the top brass. Eviscerate all records of Warm Jetty that you recieve. The Unredactor can now operate in reverse to aid in this initiative.
Oh, and the succulent company my wife bought from  called me. Due to a clerical error, every one of their succulents are getting delivered to this desk, today. I'm sure the janitor won't mind sweeping them up. 
Happy Friday."
var notepad_up:AudioStream = load("res://Assets/Sound/UnpaidIntern_SFX_NotepadUp.ogg")
var notepad_down:AudioStream = load("res://Assets/Sound/UnpaidIntern_SFX_NotepadDown.ogg")
func fade_in():
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	fade_in_finished.emit()
	sfx.stream = notepad_up
	sfx.play()
func fade_out():
	animation_player.play("Fade")
	await animation_player.animation_finished
	fade_out_finished.emit()
	sfx.stream = notepad_down
	sfx.play()


func _on_button_pressed():
	button_pressed.emit()

func _ready():
	match (day):
		Day.ONE:
			label.text = day_one_instructions
			label_2.hide()
			texture_rect_2.hide()
		Day.TWO:
			label.text = day_one_instructions + "\n" + day_two_instructions
			label_2.hide()
			texture_rect_2.hide()
		Day.THREE:
			label.text = day_one_instructions + "\n" + day_two_instructions + "\n" + day_three_instructions
			label_2.hide()
			texture_rect_2.hide()
		Day.FOUR:
			label.text = day_one_instructions + "\n" +  day_two_instructions + "\n" + day_three_instructions
			label_2.show()
			texture_rect_2.show()
			label_2.text = day_four_instructions
		Day.FIVE:
			label.text = day_one_instructions + "\n" +  day_two_instructions + "\n" + day_three_instructions
			label_2.show()
			texture_rect_2.show()
			label_2.text = day_four_instructions + "\n" + day_five_instructions
