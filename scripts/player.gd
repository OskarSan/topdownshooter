extends CharacterBody2D

@export var speed = 300
var walkSpeed = 300
var sneakSpeed = 150
@export var friction = 0.5
@export var acceleration = 0.5
@export var max_health = 100
@export var damage_amount = 25

@onready var shoot_ray_cast_2d: RayCast2D = $ShootRayCast2D
@onready var player_legs_animated_sprite: AnimatedSprite2D = $playerLegsAnimatedSprite
@onready var player_body_animated_sprite: AnimatedSprite2D = $playerBodyAnimatedSprite
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var interact_ray_cast_2d: RayCast2D = $InteractRayCast2D
@onready var camera: Camera2D = $Camera2D

#debug values
var hitAmount = 0
var health = max_health

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	if is_multiplayer_authority():
		camera.make_current()


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
	if is_multiplayer_authority():
		var mouse_pos = get_global_mouse_position()
		var viewport_rect = get_viewport_rect()
		if viewport_rect.has_point(mouse_pos):
			global_rotation = global_position.direction_to(mouse_pos).angle() + PI/2.0
	

func _physics_process(delta):
	if is_multiplayer_authority():
		var direction = get_input()
		if direction.length() > 0:
			velocity = velocity.lerp(direction.normalized() * speed, acceleration)
			player_legs_animated_sprite.play("walkingAnim")
			player_legs_animated_sprite.global_rotation = direction.angle() + PI/2.0
		else:
			velocity = velocity.lerp(Vector2.ZERO, friction)
			player_legs_animated_sprite.stop()
			player_legs_animated_sprite.frame = 1
			
		if Input.is_action_pressed("sneak"):
			speed = sneakSpeed
		else:
			speed = walkSpeed
		if Input.is_action_just_pressed("shoot"):
			shoot.rpc()
	
	move_and_slide()

	
@rpc("any_peer")
func take_damage():
	health -= damage_amount
	if health <= 0:
		health = max_health
		position = Vector2.ZERO
		

@rpc("call_local")
func shoot() -> void:
	$MuzzleFlash.show()
	$MuzzleFlash/Timer.start()
	
	if shoot_ray_cast_2d.is_colliding():
		var collider = shoot_ray_cast_2d.get_collider()
		if collider and collider is CharacterBody2D and collider != self:
			collider.take_damage.rpc_id(collider.get_multiplayer_authority())
			
