extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.5

@onready var shoot_ray_cast_2d: RayCast2D = $ShootRayCast2D
@onready var player_legs_animated_sprite: AnimatedSprite2D = $playerLegsAnimatedSprite
@onready var player_body_animated_sprite: AnimatedSprite2D = $playerBodyAnimatedSprite
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var interact_ray_cast_2d: RayCast2D = $InteractRayCast2D


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
		player_legs_animated_sprite.play("walkingAnim")
		player_legs_animated_sprite.global_rotation = direction.angle() + PI/2.0
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		player_legs_animated_sprite.stop()
		player_legs_animated_sprite.frame = 1
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()




func shoot() -> void:
	$MuzzleFlash.show()
	$MuzzleFlash/Timer.start()
	
	if shoot_ray_cast_2d.is_colliding():
		hitAmount += 1
		print(hitAmount)
	
	
