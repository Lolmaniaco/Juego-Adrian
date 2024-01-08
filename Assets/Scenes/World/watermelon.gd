extends Area2D

@onready var animation_player = $AnimationPlayer

var fading_text = preload("res://Assets/Scenes/World/fading_text.tscn")

func _process(delta):
	if not animation_player.is_playing():
		animation_player.play("idle_move")

func _on_body_entered(body):
	if not body is Player: return
	
	Journal.watermelon += 1
	
	var watermelon_text = fading_text.instantiate()
	get_parent().add_child(watermelon_text)
	watermelon_text.change_name("Watermelon")
	watermelon_text.position = global_position
	queue_free()
