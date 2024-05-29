extends CharacterBody2D

#Imports
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $DeathSound
@onready var hurt_sound = $HurtSound
@onready var collision_shape = $CollisionShape2D
@onready var death_timer = $DeathTimer
@onready var jump_buffer = $JumpBuffer
@onready var coyote_timer = $CoyoteTimer

@onready var weapon_scene = preload("res://scenes/flamethrower.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Constants
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_AMMO = 100

# Structures
enum HealthState {
	HEALTHY,
	HURT,
	DEAD,
}
enum PlayerState {
	GROUNDED,
	IN_AIR,
}

# Globals

var health = 100
var health_state = HealthState.HEALTHY
var player_state = PlayerState.GROUNDED

# Movement
var process_input = true
var direction = 0
var max_jumps = 1
var jumps = max_jumps

# Weapon Handling
var weapon_instance: Node = null
var weapon_sprite = null
var weapon_original_pos = null
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
		
		#if %GameManager.mind_controlling == false:
		if Input.is_action_just_pressed("test_e"):
			shoot()
			#if Input.is_action_just_pressed("test_f"):
			#	mind_control()
	
	# Animations
	animations(direction)
	
	move_and_slide()


# Movement functions

func movement():
	var direction_input = Input.get_axis("move_left", "move_right")
	
	if direction_input:
		velocity.x = direction_input * SPEED
		
		'''
		if weapon_instance:
			if weapon_instance.flame_instance: 
				if direction_input > 0: 
					print(weapon_instance.flame_instance.cpu_particles.gravity.x)
					weapon_instance.flame_instance.cpu_particles.gravity.x = \
					weapon_instance.flame_instance.ORIGINAL_GRAV.x + velocity.x + 2000
				if direction_input < 0: 
					print(weapon_instance.flame_instance.cpu_particles.gravity.x)
					weapon_instance.flame_instance.cpu_particles.gravity.x = \
					-weapon_instance.flame_instance.ORIGINAL_GRAV.x - velocity.x - 2000
		'''
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	return direction_input


func jumping():
	print(coyote_timer.time_left)

		
	if jumps <0:
		jumps = 0
	if !is_on_floor():
		if Input.is_action_just_pressed("jump"):
			jump_buffer.start()
			if jumps && coyote_timer.time_left != 0:
				coyote_timer.stop()
				velocity.y = JUMP_VELOCITY
				jumps -= 1
			#elif jumps:
				#velocity.y = JUMP_VELOCITY
				#jumps -= 1
	
	# Reset jumps on ground touch
	if is_on_floor():
			coyote_timer.start()
			jumps = max_jumps
			player_state = PlayerState.GROUNDED
			if Input.is_action_just_pressed("jump") || jump_buffer.time_left != 0.0:
				jump_buffer.stop()
				velocity.y = JUMP_VELOCITY
				jumps -= 1
			
	
	# Check if player wants to jump
	#if Input.is_action_just_pressed("jump"):
	#	if jumps:
	#		velocity.y = JUMP_VELOCITY
	#		jumps -= 1


func animations(facing_direction):
	sprite_flip(facing_direction, animated_sprite)
	
	if health_state == HealthState.HEALTHY:
		if is_on_floor():
			if facing_direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jumping")
	
	# Equipment animations
	equipment_animations()


func equipment_animations():
	if weapon_instance:
		weapon_sprite.flip_h = animated_sprite.flip_h
	
		if direction > 0:
			weapon_instance.position.x = weapon_original_pos.x
		elif direction < 0:
			weapon_instance.position.x = -weapon_original_pos.x

func sprite_flip(facing_direction, target):
		# Player animations
		if facing_direction > 0:
			target.flip_h = false
		elif facing_direction < 0:
			target.flip_h = true


func receive_damage(source, damage):
	print(self.name, " hurt by ", source.name, \
	" with ", source.damage, " damage.\n \
	Remaining health: ", self.health - source.damage)
	health -= source.damage
	health_state = HealthState.HURT
	hurt_sound.play()
	
	if health <= 0:
		death()
	else:
		self.animated_sprite.play("hurt")


func death():
	print("dedge")
	health = 0
	process_input = false
	Engine.time_scale = 0.5
	self.animated_sprite.play("death")
	health_state = HealthState.DEAD


func mind_control():
	%GameManager.mind_controlling = true
	var targeted_enemy = self.get_node('../Slimes/Slime')
	print(targeted_enemy)
	animated_sprite.play("death")
	targeted_enemy.mind_controlled()
	
	
	var player_script = self.get_script()
	var enemy_script = targeted_enemy.get_script()
	print(player_script)
	print(enemy_script)
	targeted_enemy.set_script('')
	targeted_enemy.set_script(player_script)
	self.set_script('')
	print(self.get_script())
	print(targeted_enemy.get_script())
	pass

#___________________________________Triggers___________________________________

func _on_animated_sprite_2d_animation_finished():
	if health_state == HealthState.HURT:
		health_state = HealthState.HEALTHY
	elif health_state == HealthState.DEAD:
		self.collision_shape.queue_free()
		death_timer.start()


func _on_death_timer_timeout():
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	


#______________________Postponed for future implementation_____________________

# Weapon Handling Functions

func equip_weapon():
	weapon_instance = weapon_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	self.add_child(weapon_instance)
	weapon_sprite = weapon_instance.get_node("WeaponSprite")
	weapon_instance.z_index = 1 #-1
	weapon_sprite.flip_h = animated_sprite.flip_h
	weapon_original_pos = weapon_instance.position
	print(weapon_instance)

func unequip_weapon():
	if weapon_instance and weapon_instance.get_parent():
		weapon_instance.get_parent().remove_child(weapon_instance)
		weapon_instance.queue_free()
		weapon_instance = null
		weapon_original_pos = null
		weapon_sprite = null

func shoot():
	if ammo:
		if weapon_instance:
			ammo -= 1
			weapon_instance.load_and_shoot()
