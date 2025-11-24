extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var character_direction : Vector2
var direction = "none"
@export var movement_speed: float = 100

func _physics_process(delta):
	if GameManager.activo:
		return

	player_movement(delta)

func player_movement(delta):
	character_direction.x = Input.get_axis("left", "right")#Teclas derecha e izquierda
	character_direction.y = Input.get_axis("up", "down")#Teclas arriba y abajo
	character_direction = character_direction.normalized()

	#Direccion de la animacion
	if character_direction.x > 0: 
		direction = "right"
	elif character_direction.x < 0:
		direction = "left"

	if character_direction.y > 0:
		direction = "down"
	elif character_direction.y < 0: 
		direction = "up"

	# Movimiento
	if character_direction:
		velocity = character_direction * movement_speed
		play_animation(1)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		play_animation(0)

	move_and_slide()

func play_animation(movement):
	var dir = direction

	if dir == "right":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("side_walk")
		elif movement == 0:
			animated_sprite_2d.play("side_idle")

	if dir == "left":
		animated_sprite_2d.flip_h = true
		if movement == 1:
			animated_sprite_2d.play("side_walk")
		elif movement == 0:
			animated_sprite_2d.play("side_idle")

	if dir == "up":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("up_walk")
		elif movement == 0:
			animated_sprite_2d.play("up_idle")

	if dir == "down":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("down_walk")
		elif movement == 0:
			animated_sprite_2d.play("down_idle")
