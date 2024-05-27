extends Area2D

# Imports
@onready var timer = $Timer

func _on_body_entered(body):
	body.receive_damage(self.get_parent(), self.get_parent().damage)


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
