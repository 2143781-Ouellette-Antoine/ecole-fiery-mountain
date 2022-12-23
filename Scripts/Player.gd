extends KinematicBody2D

var speed = 450
var jump_speed = 600
var gravity = 700
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump_speed
		
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity)
	
	position.x = clamp(position.x, $Camera2D.limit_left+30, $Camera2D.limit_right-30)
	position.y = clamp(position.y, $Camera2D.limit_top+30, $Camera2D.limit_bottom-30)
