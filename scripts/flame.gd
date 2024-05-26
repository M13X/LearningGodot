extends Node2D

# Imports
@onready var cpu_particles = $CPUParticles2D

# Constants
const SPEED = 50

# Variables
@onready var ORIGINAL_POS = position
@onready var ORIGINAL_GRAV = cpu_particles.gravity


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().weapon_sprite.flip_h:
		position.x = -ORIGINAL_POS.x
		#cpu_particles.gravity.x = -ORIGINAL_GRAV.x
	else:
		position.x = ORIGINAL_POS.x
		#cpu_particles.gravity.x = ORIGINAL_GRAV.x
	pass

func shoot(direction):
	cpu_particles.emitting = true
	if direction:
		cpu_particles.gravity.x = -cpu_particles.gravity.x
		position.x = -ORIGINAL_POS.x
	else:
		pass
