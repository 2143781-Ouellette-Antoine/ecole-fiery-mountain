extends StaticBody2D

signal platform_visited(is_special_platform)

var visited = false

func _ready():
	add_to_group("group_platforms")

func _on_DetectionArea_body_entered(body):
	if body.name != "Player" or visited==true:
		return
	visited = true
	emit_signal("platform_visited", false)
