extends State
class_name PlayerIdleState

@onready var change_gravity_timer = $"../../ChangeGravityTimer"

signal player_speaking
signal change_gravity
signal player_moving

func _ready() -> void:
	set_physics_process(false)
	set_block_signals(true)
	set_process_unhandled_input(false)

func _enter_state() -> void:
	Events.player_move = 0
	set_physics_process(true)
	set_block_signals(false)
	set_process_unhandled_input(true)

func _exit_state() -> void:
	set_physics_process(false)
	set_block_signals(true)
	set_process_unhandled_input(false)
	animator.stop()

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.is_action_pressed("ChangeGravity") and change_gravity_timer.is_stopped():
				change_gravity.emit()
			elif Input.is_action_just_pressed("Action") and Events.can_talk:
				player_speaking.emit()
			
			if Input.get_axis("KeyLeft", "KeyRight"):
				Events.player_move = Input.get_axis("KeyLeft", "KeyRight")
				player_moving.emit()

func _physics_process(_delta) -> void:
	if character.velocity.x != 0:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED/float(10))

	if not Events.crouched:
		if not animator.is_playing(): 
			animator.play("idle")

	handle_player_crouching(under_terrain)

func _on_detector_area_entered(area):
	if area.name == "NPCDetector":
		Events.can_talk = true
	
	if area.get_collision_layer() == 4:
		Events.player_dead.emit(area.name)
		print(area.name)
		character.queue_free()

func _on_detector_area_exited(area):
	if area.name == "NPCDetector":
		Events.can_talk = false

func _on_detector_body_entered(body):
	if body.name == 'TileMap':
		under_terrain = true 

func _on_detector_body_exited(body):
	if body.name == 'TileMap':
		under_terrain = false 
