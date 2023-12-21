extends State
class_name PlayerIdleState

@export var detector:Area2D

signal player_speaking
signal change_gravity
signal player_moving

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	animator.stop()

func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("ChangeGravity"):
		change_gravity.emit()
	elif Input.is_action_just_pressed("Action") and can_talk:
		print("Talking")
	else:
		if player.velocity.x != 0:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED/10)

		if not Events.crouched:
			if not animator.is_playing(): 
				animator.play("idle")

		handle_player_crouching()

		if Input.get_axis("KeyRight", "KeyLeft"):
			player_moving.emit()

func _on_detector_area_entered(area):
	if area.name == "NPCDetector":
		can_talk = true

func _on_detector_area_exited(area):
	if area.name == "NPCDetector":
		can_talk = false
