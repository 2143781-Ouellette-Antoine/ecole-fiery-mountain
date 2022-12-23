extends Node

var RandomGen : RandomNumberGenerator = RandomNumberGenerator.new()
onready var viewport_size_x = get_viewport().get_visible_rect().size.x
var score = 0
var nbr_health = 3
### Lava #####
export var custom_lava_speed = 10
var lava_speed = 0
### Platforms #####
const platform_radius = 96
const platform_distance_height = 250
var platform_last_x = 480
var platform_last_y = 80
var jump_distance = 100
var array_platform_tscn = [preload("res://Scenes/Platforms/StonePlatform.tscn"), preload("res://Scenes/Platforms/DirtPlatform.tscn"), preload("res://Scenes/Platforms/SpecialPlatform.tscn")]
var flag_tscn = preload("res://Scenes/Platforms/Flag.tscn")
var nbr_platforms = 5

func _ready():
	var NewGameButton = get_node("MenuPrincipalCanvas/MenuPrincipal/NewGameButton")
	NewGameButton.connect("pressed", self, "new_game")

func _process(delta):
	### Lava ####################
	# -move Lava Object
	$LavaArea.position.y -= lava_speed*delta
	# -grow Visual
	$LavaArea/LavaVisual.region_rect.size.y += 2*lava_speed*delta

func new_game():
	$MenuPrincipalCanvas.hide()
	score = 0
	update_score_ui()
	nbr_health = 3
	update_vies_ui()
	lava_speed = custom_lava_speed

func game_over():
	print("game over!")
	#stop Lava
	lava_speed = 0
	reset_lava()
	$Player.position = Vector2(512,432)
	print("clear the platforms...")
	$MenuPrincipalCanvas.show()

func hurt():
	nbr_health -= 1
	if nbr_health < 1:
		game_over()
	else:
		update_vies_ui()

func visited_new_platform(is_special_platform):
	if is_special_platform:
		score += 15
	else:
		score += 10
	update_score_ui()

#################################
# Flag                          #
#################################
func touched_flag(body):
	if body != $Player:
		return
	# Delete Flag
	$Flag.queue_free()
	# Score
	score += 50
	update_score_ui()
	reset_lava()
	# Teleport Player to start
	$Player.position = Vector2(512,432)
	# Reset the "visited"
	for platform in get_tree().get_nodes_in_group("group_platforms"):
		platform.visited = false
	$FirstPlatform.visited = false

#################################
# Lava                          #
#################################
# Triggered when Player touches Lava
func _on_LavaArea_body_entered(body):
	if body == $Player:
		hurt()

func reset_lava():
	$LavaArea.position.y = 568
	$LavaArea/LavaVisual.region_rect.size.y = 64

#################################
# Platforms                     #
#################################
func generate_one_platform(is_final_platform):
	# Decide left or right?
	var at_right = false
	if platform_last_x <= platform_radius:
		at_right = true
	elif platform_last_x >= viewport_size_x-platform_radius:
		at_right = false
	elif randi()%2 == 1:
		at_right = true
	else:
		at_right = false
	
	# Choose a platform type.
	var platform_type
	if is_final_platform:
		platform_type = 0
	else:
		randomize()
		platform_type = randi()%3
	
	# Generate x position of future platform.
	var platform_x = 0
	if at_right:
		#droite
		var x_min = platform_last_x + 2*platform_radius
		var x_max = viewport_size_x - platform_radius
		var reachable_x_max = clamp(platform_last_x + 2*platform_radius + jump_distance, x_min, x_max)
		
		RandomGen.randomize()
		platform_x = RandomGen.randi_range(x_min, reachable_x_max)
	else:
		#gauche
		var x_min = platform_radius
		var x_max = platform_last_x-(2*platform_radius)
		var reachable_x_min = clamp(platform_last_x - (2*platform_radius) - jump_distance, x_min, x_max)
		
		RandomGen.randomize()
		platform_x = RandomGen.randi_range(reachable_x_min, x_max)
	
	# Raise last_platform_y.
	platform_last_y -= platform_distance_height
	
	# Instanciate the Platform.
	var Platform = array_platform_tscn[platform_type].instance()
	# Set position
	Platform.position = Vector2(platform_x, platform_last_y)
	# add_child(Platform)
	call_deferred("add_child", Platform)
	# Listen to the Platform "platform_visited"
	Platform.connect("platform_visited", self, "visited_new_platform")
	
	if is_final_platform:
		# Instanciate the Flag.
		var Flag = flag_tscn.instance()
		# Set position
		Flag.position = Vector2(platform_x, platform_last_y-8)
		# add_child(Flag)
		call_deferred("add_child", Flag)
		# Listen to Flag.body_entered(body)
		Flag.connect("body_entered", self, "touched_flag")

func generate_the_new_platforms():
	# Generate n more platforms
	for i in range(1, nbr_platforms+1):
		generate_one_platform(false)
	# Generate the final platform
	generate_one_platform(true)
	nbr_platforms += 2

func _on_FirstPlatform_body_entered(body):
	if body != $Player or $FirstPlatform.visited:
		return
	$FirstPlatform.visited = true
	generate_the_new_platforms()

#################################
# UI                            #
#################################
func update_score_ui():
	# update the score label in UI
	var ScoreLabel = get_node("UICanvas/UI/ScoreHContainer/ScoreLabel")
	ScoreLabel.text = str(score)

func update_vies_ui():
	# update the health bar in UI
	$UICanvas/UI/HealthBar.value = nbr_health
