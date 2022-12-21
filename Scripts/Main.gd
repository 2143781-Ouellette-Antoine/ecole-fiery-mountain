extends Node

export var lava_speed = 10

const lava_position_initial_y = 568
var lava_y = lava_position_initial_y

func _process(delta):
	### Lava ####################
	lava_y -= lava_speed*delta
	
	# -move Lava Object
	$LavaArea.position.y = lava_y
	# -grow Visual
	$LavaArea/LavaVisual.region_rect.size.y += 2*lava_speed*delta
	
#	if Input.is_action_just_pressed("ui_accept"):
#		print("Lava", lava_y)
#		print("region", $LavaArea/LavaVisual.region_rect.size.y)

func game_over():
	print("game over!")

# Triggered when Player touches Lava
func _on_LavaArea_body_entered(body):
	if body == $Player:
		game_over()
