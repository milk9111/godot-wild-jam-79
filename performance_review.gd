extends CanvasLayer

signal accepted_review

@onready var review_text = %ReviewText
@onready var animation_player = $AnimationPlayer
@onready var accept_button = %AcceptButton
@onready var review_sheet = $ReviewSheet
@onready var title = %Title


func _ready():
	visible = false
	
func _on_accept_button_pressed():
	visible = false
	accepted_review.emit()


func show_report(day, success_count, failed_count, failures, bonus):
	title.text = "PERFORMANCE REVIEW (DAY %d)" % [day+1]
	var distinct_failures = {}
	for failure in failures:
		distinct_failures[failure] = null
	
	failures = []
	for k in distinct_failures:
		failures.append(k)
	
	visible = true
	#visibility of ReviewSheet handled by animation player 
	animation_player.play("print_report")
	
	match day:
		DayLevel.Day.ONE:
			_day_one(success_count, failed_count, failures)
		DayLevel.Day.TWO:
			_day_two(success_count, failed_count, failures)
		DayLevel.Day.THREE:
			_day_three(success_count, failed_count, failures)
		DayLevel.Day.FOUR:
			_day_four(success_count, failed_count, failures)
		#DayLevel.Day.FIVE:
			#_day_five(success_count, failed_count, failures)
	
	await animation_player.animation_finished
	accept_button.show()


func _day_four(success_count, failed_count, failures):
	var failure_text = ""
	if failures.size() > 0:
		
		failure_text = """

It seems like there were a couple of unexpected outcomes that I'd like to discuss:

[ul]
%s
[/ul]

I trust you’ll take the necessary steps to ensure this doesn’t repeat.

	""" % "\n".join(failures)
			
	var score_text = ""
	if failed_count > 0 || success_count == 0:
		score_text = "below KPI expectations. Please follow all written instructions tomorrow."
	elif success_count > 0 && success_count < 25:
		score_text = "meeting expectations. However, KPIers are extremely ambitious, so give it 110% tomorrow!"
	else:
		score_text = "exceeding expectations! Keep up the great work."
	
	review_text.parse_bbcode("""
Date: 02/22/1999
To: Whom it may concern
From: Bob Thompson, Senior Regional Vice President
Subject: Internship Performance Evaluation

Thank you for your continued efforts at KPI Corp! Your hard work doesn’t go unnoticed. We’ve compiled your latest performance insights. Here is your daily Internship Performance Evaluation (IPE)

[ul]
 Total tasks assigned: %d
 Completed tasks: %d
 Growth opportunities: %d
[/ul]
%s
Overall, we believe you are %s

Thank you,

Bob Thompson
Senior Regional Vice President
	""" % [success_count + failed_count, success_count, failed_count, failure_text, score_text])


func _day_three(success_count, failed_count, failures):
	var failure_text = ""
	if failures.size() > 0:
		
		failure_text = """

I’d like to talk through a few opportunities for improvement on this:

[ul]
%s
[/ul]

Let’s take this as a learning moment and move forward with more precision, mkay?

	""" % "\n".join(failures)
			
	var score_text = ""
	if failed_count > 0 || success_count == 0:
		score_text = "below KPI expectations. Please follow all written instructions tomorrow."
	elif success_count > 0 && success_count < 20:
		score_text = "meeting expectations. However, KPIers are extremely ambitious, so give it 110% tomorrow!"
	else:
		score_text = "exceeding expectations! Keep up the great work."
	
	review_text.parse_bbcode("""
Date: 02/21/1999
To: Whom it may concern
From: Bob Thompson, Branch Director
Subject: Internship Performance Evaluation

Thank you for your commitment to excellence at KPI Corp! Your contributions matter, and we’ve prepared your daily Internship Performance Evaluation (IPE) to reflect your progress.

[ul]
 Total tasks assigned: %d
 Completed tasks: %d
 Growth opportunities: %d
[/ul]
%s
Overall, we believe you are %s

Thank you,

Bob Thompson
Branch Director
	""" % [success_count + failed_count, success_count, failed_count, failure_text, score_text])



func _day_two(success_count, failed_count, failures):
	var failure_text = ""
	if failures.size() > 0:
		
		failure_text = """

It looks like there were a few missteps—let’s go over them:

[ul]
%s
[/ul]

I appreciate your effort, but let’s align on how to avoid this in the future.

	""" % "\n".join(failures)
			
	var score_text = ""
	if failed_count > 0 || success_count == 0:
		score_text = "below KPI expectations. Please follow all written instructions tomorrow."
	elif success_count > 0 && success_count < 15:
		score_text = "meeting expectations. However, KPIers are extremely ambitious, so give it 110% tomorrow!"
	else:
		score_text = "exceeding expectations! Keep up the great work."
	
	review_text.parse_bbcode("""
Date: 02/20/1999
To: Whom it may concern
From: Bob Thompson, Office Manager
Subject: Internship Performance Evaluation

I hope you had a wonderful second day with us at KPI Corp. The effort you put in is valuable and treasured! We've crunched the numbers, so here is your daily Internship Performance Evaluation (IPE)!

[ul]
 Total tasks assigned: %d
 Completed tasks: %d
 Growth opportunities: %d
[/ul]
%s
Overall, we believe you are %s

Thank you,

Bob Thompson
Office Manager
	""" % [success_count + failed_count, success_count, failed_count, failure_text, score_text])


func _day_one(success_count, failed_count, failures):
	var failure_text = ""
	if failures.size() > 0:
		
		failure_text = """

It's my understanding that you hit some unexpected roadblocks:

[ul]
%s
[/ul]

We believe that everyone here at KPI is capable of world-class excellence. This is a great time to reflect, learn, and level-up your skillset!

	""" % "\n".join(failures)
			
	var score_text = ""
	if failed_count > 0 || success_count == 0:
		score_text = "below KPI expectations. Please follow all written instructions tomorrow."
	elif success_count > 0 && success_count < 10:
		score_text = "meeting expectations. However, KPIers are extremely ambitious, so give it 110% tomorrow!"
	else:
		score_text = "exceeding expectations! Keep up the great work."
	
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
%s
Overall, we believe you are %s

Thank you,

Bob Thompson
Floor Supervisor
	""" % [success_count + failed_count, success_count, failed_count, failure_text, score_text])
