extends CanvasLayer

signal accepted_review

@onready var success_count_label = %SuccessCountLabel
@onready var failed_count_label = %FailedCountLabel
@onready var nudged_count_label = %NudgedCountLabel
@onready var day_label = %DayLabel

func _ready():
	visible = false

func show_report(day, success_count, failed_count, nudged_count):
	day_label.text = "DAY %d" % day
	success_count_label.text = "Succeeded:\t\t\t%d" % success_count
	failed_count_label.text = "Failed:\t\t\t\t\t%d" % failed_count
	nudged_count_label.text = "Nudged:\t\t\t\t\t%d" % nudged_count
	visible = true


func _on_accept_button_pressed():
	visible = false
	accepted_review.emit()
