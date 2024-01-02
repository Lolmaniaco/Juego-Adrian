extends State
class_name PlayerSpeakingState

signal dialogue_finished

func _ready() -> void:
	Events.dialogue_ended.connect(_on_dialogue_ended)
	set_physics_process(false)
	set_block_signals(true)

func _enter_state() -> void:
	set_physics_process(true)
	set_block_signals(false)

func _exit_state() -> void:
	set_physics_process(false)
	set_block_signals(true)

func _physics_process(_delta) -> void:
	if character.velocity.x != 0:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED/float(10))

func _on_dialogue_ended(_name:String) -> void:
	dialogue_finished.emit()
