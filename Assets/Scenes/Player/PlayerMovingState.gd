extends State
class_name PlayerMovingState

@export var animatedSprite: AnimatedSprite2D

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	var player_move
	
	if gravity < 0:
		player_move = Input.get_axis("KeyRight", "KeyLeft")	
	else:
		player_move = Input.get_axis("KeyLeft", "KeyRight")
	flip_player_sprite(player_move)

func flip_player_sprite(player_move) -> void:
	if gravity < 0:
		player_move *= -1

	if player_move == -1:
		animatedSprite.flip_h = true
	elif player_move == 1:
		animatedSprite.flip_h = false
