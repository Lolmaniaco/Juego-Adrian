extends State
class_name PlayerGravityState

@export var remoteTransform: RemoteTransform2D

@onready var change_gravity_timer = $"../../ChangeGravityTimer"

signal gravity_changed

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	if character.gravity >= 0:
		animator.play("change_gravity_up")
	else:
		animator.play("change_gravity_down")
	await animator.animation_finished
	remoteTransform.rotate(PI)
	character.gravity *= -1
	gravity_changed.emit()

func _exit_state():
	change_gravity_timer.start()
