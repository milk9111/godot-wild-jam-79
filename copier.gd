extends Area2D


@onready var scan_complete = $ScanComplete
@onready var scan_destroyed = $ScanDestroyed
@onready var check_area_timer = $CheckArea
@onready var cpu_particles_2d = $CPUParticles2D
@onready var sfx = $AudioStreamPlayer2D
@onready var scan_danger = $ScanDanger
@onready var explosion_particles = $CPUParticles2D

var currently_processing_node:Node
var done_sfx:AudioStream = load("res://Assets/Sound/ScannerBeep_ZA02.449.wav")
var countdown_sfx:AudioStream = load("res://Assets/Sound/ScannerBeepsIncrease_HV.716.wav")
var puff_sfx:AudioStream = load("res://Assets/Sound/FNF_WW_foley_potions_conjure_exploding_small_poof.wav")
@onready var explosion = $explosion

func _on_area_entered(area):
	var area_parent = area.get_parent()
	print(area_parent.redacted)
	if area_parent.redacted == true and area_parent.is_held:
		check_area_timer.start()


func _on_area_exited(area):
	var area_parent = area.get_parent()
	if area_parent.redacted == true and area_parent.is_held:
		check_area_timer.stop()
	if area_parent == currently_processing_node:
		currently_processing_node = null
		scan_danger.stop()
		scan_complete.stop()
		scan_destroyed.stop()
	if sfx.playing:
		sfx.stop()



func _on_scan_complete_timeout():
	print("reenabling redacted node")
	currently_processing_node.redacted = false
	
	currently_processing_node.state = currently_processing_node.State.DROPPED
	sfx.stream = done_sfx
	sfx.play()
	await sfx.finished
	scan_complete.stop()
	scan_danger.start()
	

func _on_scan_destroyed_timeout():
	scan_destroyed.stop()
	explosion.play()
	explosion_particles.emitting = true
	if currently_processing_node:
		
		currently_processing_node.queue_free()
		print("Redacted document destroyed!")
		EventBus.failed_placement.emit("Un-Redacter destroyed file")


func _on_check_area_timeout():
	check_area()
	
	
func check_area():
	var overlapping_areas = self.get_overlapping_areas()
	if overlapping_areas:
		var node_to_process = overlapping_areas.pop_front().get_parent()
		if not node_to_process.is_held:
			print("starting to process redacted document")
			check_area_timer.stop()
			node_to_process.state = node_to_process.State.QUEUED
			node_to_process.currently_unredacting = true
			currently_processing_node = node_to_process
			scan_complete.start()
			


func _on_scan_danger_timeout():
	scan_danger.stop()
	scan_destroyed.start()
	sfx.stream = countdown_sfx
	sfx.play()
