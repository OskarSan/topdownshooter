extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.5
@export var bullet_scene: PackedScene


func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot() -> void:
	
	
	var mousePosition = get_global_mouse_position()
	var direction = (mousePosition - global_position).normalized()
	var bullet = bullet_scene.instance()
	bullet.global_position = global_position
	bullet.direction(direction)
	get_parent().add_child(bullet)
	
	
