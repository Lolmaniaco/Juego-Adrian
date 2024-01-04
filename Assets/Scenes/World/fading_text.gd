extends Node2D

@onready var rich_text_label = $RichTextLabel
@onready var animation_player = $AnimationPlayer

var start_animation:bool = false

func change_name(name:String):
	rich_text_label.text = "[center]"+name
	animation_player.play("fade_up")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_up":
		queue_free()
