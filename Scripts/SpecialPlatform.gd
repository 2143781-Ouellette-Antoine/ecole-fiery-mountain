extends StaticBody2D

signal platform_visited(is_special_platform)

var visited = false
var is_ongoing_effect = false

func _ready():
	add_to_group("group_platforms")

func _on_DetectionArea_body_entered(body):
	if body.name != "Player":
		return
	# Visited ?
	if visited==false:
		visited = true
		emit_signal("platform_visited", true)
	# Special Effect.
	if is_ongoing_effect==false:
		is_ongoing_effect = true
		$SpecialEffectTimer.start()

func _on_SpecialEffectTimer_timeout():
	is_ongoing_effect = false
	queue_free()
