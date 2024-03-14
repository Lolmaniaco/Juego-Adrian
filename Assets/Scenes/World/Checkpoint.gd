extends Area2D

@export var checkpoint_name: float = 0


func _on_body_entered(body):
	if not body is Player: return
	Journal.set_checkpoint(checkpoint_name, global_position)
