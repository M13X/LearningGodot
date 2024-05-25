extends Node2D

# Imports
@onready var weapon_sprite = $WeaponSprite
@onready var rocket_timer = $RocketTimer
var rocket_scene = preload("res://scenes/rocket.tscn")

# Variables
var shooting = false


func _process(delta):
	if rocket_timer.time_left <= 0:
		shooting = false
		if self.has_node("Rocket"):
			get_node("Rocket").queue_free()


func load_and_shoot():
	if not shooting:
		var rocket_instance = rocket_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		self.add_child(rocket_instance)
		rocket_instance.position = Vector2(0, -5)
			
		if self.has_node("Rocket"):
			print(get_node("Rocket").get_children())
			self.get_node("Rocket").shoot(weapon_sprite.flip_h)
			rocket_timer.start()
			shooting = true
