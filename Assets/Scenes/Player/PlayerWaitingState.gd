extends State
class_name PlayerWaitingState

func _ready() -> void:
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
		character.velocity.x = 0
	
	if not animator.is_playing(): 
		animator.play("idle")
