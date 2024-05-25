extends Area2D

const INVINCIBLE_LAYER = 5

func _layer_set(layer):
	return  1 << (layer - 1)


func _on_body_entered(body):
	print("powerup body")
	body.collision_layer = _layer_set(INVINCIBLE_LAYER)
	self.get_node("..").queue_free()
