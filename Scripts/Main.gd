extends Node

onready var viewport_size_x = get_viewport().get_visible_rect().size.x
### Lava #####
export var lava_speed = 10
### Platforms #####
const platform_radius = 128
const platform_distance_height = 320
var platform_last_x = 0
var platform_last_y = 0
var jump_distance = 300
var array_platforms = [preload("res://Scenes/Platforms/StonePlatform.tscn"), preload("res://Scenes/Platforms/DirtPlatform.tscn"), preload("res://Scenes/Platforms/SpecialPlatform.tscn")]

func _process(delta):
	### Lava ####################
	# -move Lava Object
	$LavaArea.position.y -= lava_speed*delta
	# -grow Visual
	$LavaArea/LavaVisual.region_rect.size.y += 2*lava_speed*delta

func new_game():
	print("MenuPrincipal.hide()")
	print("score = 0")
	print("Wait player moves...")
	print("lava_speed = 10")#10 is initial lava_speed

func game_over():
	print("game over!")
	print("lava_speed = 0")
	print("clear game...")
	print("MenuPrincipal.show()")
	print("last score: ...")

#################################
# Flag                          #
#################################
func touch_flag():
	print("score: +100")
	print("lava reset ...")
	print("teleport start ...")

#################################
# Lava                          #
#################################
# Triggered when Player touches Lava
func _on_LavaArea_body_entered(body):
	if body == $Player:
		game_over()

#################################
# Platforms                     #
#################################
func generate_a_platform():
	var at_right = false
	var platform_x = 0
	# Decide left or right?
	if randi()%2 == 1:
		at_right = true
	
	# Choose a platform type.
	var platform_type = randi()%3
	
	# Generate x position of future platform.
	if at_right==false:
		#gauche
		var x_min = platform_radius
		var reachable_x_min = platform_last_x-2*platform_radius-jump_distance
		var x_max = platform_last_x-2*platform_radius
		platform_x = clamp( randi()*(x_max - x_min) + x_min, reachable_x_min, x_max ) #randi entre [min,max]
	else:
		#droite
		var x_min = platform_last_x+2*platform_radius
		var x_max = viewport_size_x-platform_radius
		var reachable_x_max = platform_last_x+2*platform_radius+jump_distance
		platform_x = clamp( randi()*(x_max - x_min) + x_min, x_min, reachable_x_max )
	
	# Raise last_platform_y.
	platform_last_y += platform_distance_height
	
	# Instanciate the Platform.
	var Platform = array_platforms[platform_type].instance()
	Platform.position = Vector2(platform_x, platform_last_y)
	add_child(Platform)
