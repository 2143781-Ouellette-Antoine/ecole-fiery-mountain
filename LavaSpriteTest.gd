extends Sprite

# Set the rate at which the sprite will grow
var growth_rate = 0.1

# Set the tiling amount for the sprite's image
var tiling = 10

# Set a timer to update the sprite's scale and tiling every frame
var timer

func _ready():
  timer = Timer.new()
  add_child(timer)
  timer.connect("timeout", self, "_on_timer_timeout")
  timer.start()

func _on_timer_timeout():
  # Increase the sprite's scale by the growth rate
  set_scale(Vector2(scale.x, scale.y + growth_rate))

  # Set the sprite's tiling to the desired amount
  set_v_tiling(tiling)
