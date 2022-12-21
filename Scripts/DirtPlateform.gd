extends StaticBody2D

signal visited_new_platform

func _process(delta):
	#if not already visited, give points.
	if $DetectionArea.visible:
		emit_signal('visited_new_platform')
		#save visited state
		$DetectionArea.hide()
