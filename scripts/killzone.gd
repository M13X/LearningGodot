extends Area2D

# Imports
@onready var timer = $Timer

func _on_body_entered(body):
	print("dedge")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	body.process_input = false
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
