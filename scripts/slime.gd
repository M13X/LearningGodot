extends Node2D

# Imports
@onready var ray_cast_front = $RayCastFront
@onready var ray_cast_hole = $RayCastHole
@onready var animated_sprite = $AnimatedSprite2D

# Constants
const SPEED = 60

# Variables
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_front.is_colliding() or !ray_cast_hole.is_colliding():
		ray_cast_front.target_position.x = -ray_cast_front.target_position.x
		ray_cast_hole.position.x = -ray_cast_hole.position.x
		direction = -direction
		animated_sprite.flip_h = !animated_sprite.flip_h

	position.x +=  direction * SPEED * delta


func _on_killzone_body_entered(body):
	body.death_sound.play()
