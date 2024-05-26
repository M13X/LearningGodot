extends Area2D


func _on_body_entered(body):
	self.get_parent().queue_free()
	body.equip_weapon()
