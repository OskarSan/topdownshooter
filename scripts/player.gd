extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.5

@onready var ray_cast_2d: RayCast2D = $RayCast2D


#debug values
var hitAmount = 0



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

func _process(delta):
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0


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
	$MuzzleFlash.show()
	$MuzzleFlash/Timer.start()
	
	if ray_cast_2d.is_colliding():
		hitAmount += 1
		print(hitAmount)
	
	
