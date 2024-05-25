extends Node2D

# Imports
@onready var cpu_particles = $CPUParticles2D

# Constants
const SPEED = 50

# Variables
var shooting = false
var direction_of_shooting = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shooting:
		position.x = position.x + direction_of_shooting * SPEED *delta

func shoot(direction):
	cpu_particles.emitting = true
	shooting = true
	if direction:
		direction_of_shooting = -1
		print("Rocket going out LEFT")
	else:
		direction_of_shooting = 1
		cpu_particles.gravity.x = -cpu_particles.gravity.x
		print("Rocket going out RIGHT")
