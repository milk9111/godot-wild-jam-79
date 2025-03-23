extends Area2D



var current_processing_node:Node
var is_active:bool
var cooldown_process: float 
var cooldown_warning:float
var cooldown_destroy:float
var is_node_redacted
var is_node_warm_jetty
func _process(delta):
	if not current_processing_node:
		current_processing_node = get_first_overlapping_node()
	if current_processing_node:
		get_node_status()
	if is_node_redacted:
		cooldown_process-=delta
		if cooldown_process == 0:
			current_processing_node.redacted = false
			pass
		
			

func get_first_overlapping_node():
	if get_overlapping_areas():
		return get_overlapping_areas().pop_front().get_parent()

func get_node_status():
	if current_processing_node:
		is_node_redacted = current_processing_node.redacted
		if current_processing_node.text == "Warm Jetty":
			is_node_warm_jetty = true
		else:
			is_node_warm_jetty = true
	
