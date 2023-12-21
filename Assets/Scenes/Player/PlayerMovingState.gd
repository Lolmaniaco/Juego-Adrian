extends State
class_name PlayerMovingState

@export var animatedSprite: AnimatedSprite2D
@export var detector:Area2D

signal player_stopped
signal change_gravity

var player_move:float

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
	else:
		handle_sprite_flip(player_move)
		
		if player.gravity < 0:
			player_move = Input.get_axis("KeyRight", "KeyLeft")	
		else:
			player_move = Input.get_axis("KeyLeft", "KeyRight")
		
		if player_move == 0:
			player_stopped.emit()
		else:
			handle_player_crouching()
			if not Events.crouched:
				animator.play("walk")
			player.velocity.x = move_toward(player.velocity.x, player_move * SPEED, SPEED)

func handle_sprite_flip(player_move) -> void:
	if player.gravity > 0:
		player_move *= -1
	
	if player_move == 1:
		animatedSprite.flip_h = true
	elif player_move == -1:
		animatedSprite.flip_h = false
