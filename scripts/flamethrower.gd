extends Node2D

# Imports
@onready var weapon_sprite = $WeaponSprite
@onready var flame_timer = $FlameTimer
var flame_scene = preload("res://scenes/flame.tscn")
var flame_instance = null

# Constants
#const BULLET_SPAWN_POSITION = Vector2(0, -5)
# Variables
var shooting = false


func _process(delta):
	if flame_timer.time_left <= 0:
		shooting = false
		if self.has_node("Flame"):
			flame_instance = null
			get_node("Flame").queue_free()


func load_and_shoot():
	if not shooting:
		flame_instance = flame_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		self.add_child(flame_instance)
			
		if self.has_node("Flame"):
			print(get_node("Flame").get_children())
			self.get_node("Flame").shoot(weapon_sprite.flip_h)
			flame_timer.start()
			shooting = true
