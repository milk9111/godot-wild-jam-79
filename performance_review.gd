extends CanvasLayer

signal accepted_review

@onready var success_count_label = %SuccessCountLabel
@onready var failed_count_label = %FailedCountLabel
@onready var failures_label = %FailuresLabel
@onready var failures_description = %FailuresDescription
@onready var bonus_objectives = %BonusObjectivesLabel
@onready var bonus_objectives_description = %BonusObjectivesDescription

func _ready():
	visible = false

func show_report(success_count, failed_count, failures,bonus):
	success_count_label.text = "Completed tasks:\t\t\t%d" % success_count
	bonus_objectives.text = "Bonus objectives:"
	bonus_objectives_description.text = "\n".join(bonus)
	failed_count_label.text = "Failed tasks:\t\t\t\t\t%d" % failed_count
	failures_label.text = "Failures: " 
	failures_description.text = "\n".join(failures)
	visible = true


func _on_accept_button_pressed():
	visible = false
	accepted_review.emit()
