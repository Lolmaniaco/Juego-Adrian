extends Path2D

enum pos {FINISH, START}
@export var ACTUAL_POS = pos.START
@export var ANIM_SPEED: float = 1
@export var progress_ratio: float = 0

@onready var animation_player = $PathFollow2D/StaticBody2D/AnimationPlayer
@onready var remote_transform_2d = $PathFollow2D/StaticBody2D/RemoteTransform2D
@onready var path_follow_2d = $PathFollow2D

var temp_player: Player = null
var activate_elevator: bool = false

func _ready():
	path_follow_2d.progress_ratio = progress_ratio

func _process(_delta):
	if not temp_player: return
	if Input.is_action_just_pressed("Action") and not animation_player.is_playing():
		use_elevator()
		if ACTUAL_POS == pos.START:
			ACTUAL_POS = pos.FINISH
		else:
			ACTUAL_POS = pos.START

func use_elevator():
	animation_player.play("activate_lever")
	remote_transform_2d.remote_path = temp_player.get_path()
	temp_player.player_is_waiting()
	
	animation_player.set_speed_scale(ANIM_SPEED)
	if ACTUAL_POS == pos.START:
		animation_player.queue("elevator_go")  
	else:
		animation_player.queue("elevator_back")
	await animation_player.animation_finished
	
	animation_player.queue("idle_lever")
	remote_transform_2d.remote_path = ""
	temp_player.player_finished_waiting()

func _on_area_2d_body_entered(body):
	if not body is Player: return
	temp_player = body

func _on_area_2d_body_exited(body):
	if not body is Player: return
	temp_player = null
