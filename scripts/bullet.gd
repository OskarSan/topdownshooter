extends Area2D

@export var bulletSpeed = 400
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * bulletSpeed * delta
	
	
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()
