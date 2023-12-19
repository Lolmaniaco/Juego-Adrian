extends Path2D

enum pos {UP, DOWN}
@export var ACTUAL_POS = pos.DOWN
@export var ANIM_SPEED: float = 1

@onready var animation_player = $PathFollow2D/StaticBody2D/AnimationPlayer
@onready var remote_transform_2d = $PathFollow2D/StaticBody2D/RemoteTransform2D

var temp_player
var activate_elevator: bool = false

func _process(_delta):
	if not temp_player: return
	if Input.is_action_just_pressed("Action") and not animation_player.is_playing():
		use_elevator()
		if ACTUAL_POS == pos.DOWN:
			ACTUAL_POS = pos.UP
		else:
			ACTUAL_POS = pos.DOWN

func anchor_player():
	remote_transform_2d.remote_path = temp_player.get_path()

func use_elevator():
	animation_player.play("activate_lever")
	anchor_player()
	animation_player.set_speed_scale(ANIM_SPEED)
	if ACTUAL_POS == pos.DOWN:
		animation_player.queue("elevator_go")
	else:
		animation_player.queue("elevator_back")
	animation_player.queue("idle_lever")
	
func _on_area_2d_body_entered(body):
	if not body is Player: return
	temp_player = body

func _on_area_2d_body_exited(body):
	if not body is Player: return
	temp_player = null
