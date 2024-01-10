extends State
class_name NPCIdleState

#character, animator, detector

signal NPC_started_speaking

@export var hysteresis:Timer
@export var animatedSprite:AnimatedSprite2D

var player:Player
var player_close:bool = false

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	Events.player_move = 0
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	animator.stop()
 
func _physics_process(_delta):
	if not player:
		if player_close:
			if hysteresis.is_stopped():
				hysteresis.start()
		else:
			if not animator.is_playing():
				animator.play("idle")
	else:
		player_close = true
		if hysteresis.time_left > 0:
			hysteresis.stop()
		if character.global_position.x - player.global_position.x > 0:
			animatedSprite.flip_h = true
		else:
			animatedSprite.flip_h = false
		animator.play("side")
		
		if Input.is_action_just_pressed("Action"):
			NPC_started_speaking.emit()
		
func _on_npc_detector_body_entered(body):
	if not body is Player: return
	player = body

func _on_npc_detector_body_exited(body):
	if not body is Player: return
	player = null

func _on_hysteresis_timeout():
	player_close = false
