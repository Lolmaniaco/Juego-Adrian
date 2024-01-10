extends State
class_name PlayerHidingState

signal player_moving

var safe_movement_timer:Timer = Timer.new()

func _ready() -> void:
	safe_movement_timer.wait_time = float(0.2)
	safe_movement_timer.one_shot = true
	add_child(safe_movement_timer)
	set_block_signals(true)
	set_process_unhandled_input(false)

func _enter_state() -> void:
	animator.play("duck_down")
	safe_movement_timer.start()
	character.velocity = Vector2.ZERO
	detector.set_collision_mask_value(3, false)
	character.z_index = 0
	set_block_signals(false)
	set_process_unhandled_input(true)

func _exit_state() -> void:
	animator.play("duck_up")
	detector.set_collision_mask_value(3, true)
	character.z_index = 100
	set_block_signals(true)
	set_process_unhandled_input(false)

func _unhandled_input(event) -> void:
	if safe_movement_timer.is_stopped():
		if event is InputEventKey:
			if event.pressed:
				if Input.get_axis("KeyLeft", "KeyRight"):
					Events.player_move = Input.get_axis("KeyLeft", "KeyRight")
					player_moving.emit()
