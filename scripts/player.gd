extends CharacterBody2D

#Imports
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $DeathSound
@onready var weapon_scene = preload("res://scenes/bazooka.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Constants
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_AMMO = 1
const BAZOOKA_ROTATION = -5

# Globals

# Movement
var process_input = true
var direction = 0
var max_jumps = 2
var jumps = max_jumps

# Weapon Handling
var weapon_instance: Node = null
var ammo = MAX_AMMO


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if process_input:
		# Handling movement
		direction = movement()
		# Handling jump
		jumping()
		
		if Input.is_action_just_pressed("test_e"):
			shoot()
	
	# Animations
	animations(direction)
	
	move_and_slide()


# Movement functions

func movement():
	var direction_input = Input.get_axis("move_left", "move_right")
	
	if direction_input:
		velocity.x = direction_input * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	return direction_input


func jumping():
	# Reset jumps on ground touch
	if is_on_floor():
			jumps = max_jumps
	
	# Check if player wants to jump
	if Input.is_action_just_pressed("jump"):
		if jumps:
			velocity.y = JUMP_VELOCITY
			jumps -= 1


func animations(facing_direction):
	sprite_flip(facing_direction, animated_sprite)
	
	if is_on_floor():
		if facing_direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumping")
		
	# Equipment animations
	if weapon_instance:
		var weapon_sprite = weapon_instance.get_node("WeaponSprite")
		if direction > 0:
			weapon_sprite.flip_h = false
			weapon_sprite.rotation_degrees = BAZOOKA_ROTATION
		elif direction < 0:
			weapon_sprite.flip_h = true
			weapon_sprite.rotation_degrees = -BAZOOKA_ROTATION


func sprite_flip(facing_direction, target):
		# Player animations
		if facing_direction > 0:
			target.flip_h = false
		elif facing_direction < 0:
			target.flip_h = true


# Weapon Handling Functions

func equip_weapon():
	weapon_instance = weapon_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	self.add_child(weapon_instance)
	weapon_instance.position = Vector2(0, BAZOOKA_ROTATION)
	weapon_instance.z_index = -1
	print(weapon_instance)

func unequip_weapon():
	if weapon_instance and weapon_instance.get_parent():
		weapon_instance.get_parent().remove_child(weapon_instance)
		weapon_instance.queue_free()
		weapon_instance = null

func shoot():
	if ammo:
		if weapon_instance:
			ammo -= 1
			weapon_instance.load_and_shoot()
