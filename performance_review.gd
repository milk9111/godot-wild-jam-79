extends CanvasLayer

signal accepted_review

@onready var review_text = %ReviewText
@onready var animation_player = $AnimationPlayer
@onready var accept_button = %AcceptButton
@onready var review_sheet = $ReviewSheet


func _ready():
	visible = false
	
func _on_accept_button_pressed():
	visible = false
	accepted_review.emit()


func show_report(day, success_count, failed_count, failures, bonus):
	visible = true
	#visibility of ReviewSheet handled by animation player 
	animation_player.play("print_report")
	
	match day:
		DayLevel.Day.ONE:
			review_text.parse_bbcode("""
Date: 02/19/1999
To: Whom it may concern
From: Bob Thompson, Floor Supervisor
Subject: Internship Performance Evaluation

It has been a blast having you be a part of our little family here at KPI Corp. After analyzing system data and compiling peer feedback, we wanted to share with you your daily Internship Performance Evaluation (IPE)!

[ul]
 Total tasks assigned: %d
 Completed tasks: %d
 Growth opportunities: %d
[/ul]

It's my understanding that you hit some unexpected roadblocks:

[ul]
%s
[/ul]
			""" % [success_count + failed_count, success_count, failed_count, "\n".join(failures)])
	await animation_player.animation_finished
	accept_button.show()
