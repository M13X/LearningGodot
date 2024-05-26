extends CharacterBody2D

# Imports
@onready var ray_cast_front = $RayCastFront
@onready var ray_cast_hole = $RayCastHole
@onready var animated_sprite = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Constants
const SPEED = 70.0

# Variables
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * SPEED
	
	move_and_slide()
	
	if ray_cast_front.is_colliding() or !ray_cast_hole.is_colliding():
		ray_cast_front.target_position.x = -ray_cast_front.target_position.x
		ray_cast_hole.position.x = -ray_cast_hole.position.x
		direction = -direction
		animated_sprite.flip_h = !animated_sprite.flip_h


func _on_killzone_body_entered(body):
	body.death_sound.play()
