extends State
class_name PlayerSpeakingState

signal dialogue_finished

func _ready() -> void:
	Events.dialogue_ended.connect(_on_dialogue_ended)
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	if player.velocity.x != 0:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED/10)

func _on_dialogue_ended():
	dialogue_finished.emit()
