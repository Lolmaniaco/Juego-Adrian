extends CharacterBody2D
class_name Player

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -400.0

@onready var playerAnimatedSprite = $PlayerAnimatedSprite
@onready var playerAnimationPlayer = $AnimationPlayer
@onready var remoteTransform = $RemoteTransform2D
@onready var change_gravity_timer = $ChangeGravityTimer
@onready var safe_animation = $SafeAnimation

enum {IDLE, MOVING, CROUCH, CROUCH_MOVING, GRAVITY, SPEAKING} 
var state_names = ["IDLE", "MOVING", "CROUCH", "CROUCH_MOVING", "GRAVITY", "SPEAKING"]
var state = IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_player_ducked: bool = false
var stop_crouching: bool = false
var under_terrain: bool = false
var can_talk: bool = false

var action_flag:bool = false


func _ready() -> void:
	Events.dialogue_ended.connect(_on_dialogue_ended)
	change_gravity_timer.start()

func _on_dialogue_ended(_var: String) -> void:
	state = IDLE

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("Action"):
			action_flag = true

func _physics_process(delta) -> void:
	apply_gravity(delta)

	if can_talk and action_flag:
		action_flag = false
		state = SPEAKING

	var player_move
	if gravity < 0:
		player_move = Input.get_axis("KeyRight", "KeyLeft")	
	else:
		player_move = Input.get_axis("KeyLeft", "KeyRight")
	flip_player_sprite(player_move)

	match state:
		IDLE: idle_state(player_move)
		MOVING: moving_state(player_move)
		CROUCH: crouch_state(player_move)
		CROUCH_MOVING: crouch_moving_state(player_move)
		GRAVITY: gravity_swap_state()
		SPEAKING: speaking_state()

	move_and_slide()

func idle_state(player_move) -> void:
	#if not playerAnimationPlayer.is_playing():
		#playerAnimationPlayer.play("idle")
		
	#if velocity.x != 0:
		#velocity.x = move_toward(velocity.x, 0, SPEED/10)

	if Input.is_action_just_pressed("ChangeGravity") and change_gravity_timer.time_left == 0:
		playerAnimationPlayer.stop()
		change_gravity_timer.start()
		state = GRAVITY
	elif player_move != 0 and safe_animation.time_left == 0:
		playerAnimationPlayer.stop()
		state = MOVING
	elif Input.is_action_pressed("KeyDown") and safe_animation.time_left == 0:
		playerAnimationPlayer.stop()
		state = CROUCH

func moving_state(player_move) -> void:
	if player_move == 0:
		playerAnimationPlayer.stop()
		state = IDLE
	else:
		if not playerAnimationPlayer.is_playing():
			playerAnimationPlayer.play("walk")
		velocity.x = move_toward(velocity.x, player_move * SPEED, SPEED)

	if Input.is_action_just_pressed("ChangeGravity") and change_gravity_timer.time_left == 0:
		playerAnimationPlayer.stop()
		change_gravity_timer.start()
		state = GRAVITY
	elif Input.is_action_pressed("KeyDown") and safe_animation.time_left == 0:
		playerAnimationPlayer.stop()
		state = CROUCH_MOVING

func crouch_state(player_move) -> void:
	if not is_player_ducked:
		playerAnimationPlayer.play("duck_down")
		is_player_ducked = true

	if Input.is_action_just_released("KeyDown"):
		stop_crouching = true

	if not under_terrain and stop_crouching:
		state = IDLE
		is_player_ducked = false
		stop_crouching = false
		playerAnimationPlayer.play("duck_up")
	
	if player_move != 0:
		state = CROUCH_MOVING
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func crouch_moving_state(player_move) -> void:
	if player_move == 0:
		playerAnimationPlayer.stop(true)
		state = CROUCH
	else: 
		if not is_player_ducked:
			playerAnimationPlayer.play("duck_down")
			is_player_ducked = true
		
		velocity.x = move_toward(velocity.x, player_move * SPEED, SPEED)
		if Input.is_action_just_released("KeyDown"):
			stop_crouching = true
		
		if not under_terrain and stop_crouching:
			state = MOVING
			is_player_ducked = false
			stop_crouching = false
			playerAnimationPlayer.play("duck_up")

func gravity_swap_state() -> void:
	if gravity >= 0:
		playerAnimationPlayer.play("change_gravity_up")
	else:
		playerAnimationPlayer.play("change_gravity_down")
	await playerAnimationPlayer.animation_finished
	state = IDLE

func speaking_state() -> void:
	if velocity.x != 0:
		velocity.x = move_toward(velocity.x, 0, SPEED/10)

func flip_player_sprite(player_move) -> void:
	if gravity < 0:
		player_move *= -1

	if player_move == -1:
		playerAnimatedSprite.flip_h = true
	elif player_move == 1:
		playerAnimatedSprite.flip_h = false

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func is_player_jumping() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func connect_camera(camera) -> void:
	var camera_path = camera.get_path()
	remoteTransform.remote_path = camera_path
	remoteTransform.rotation = camera.rotation

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "change_gravity_up" or anim_name == "change_gravity_down":
		remoteTransform.rotate(PI)
		gravity *= -1

func _on_detector_area_entered(area) -> void:
	if area.name == "NPCDetector":
		can_talk = true

	if area.get_collision_layer() == 4:
		Events.player_dead.emit(area.name)
		queue_free()

func _on_detector_area_exited(area) -> void:
	if area.name == "NPCDetector":
		can_talk = false

	if area.collision_layer == 3:
		print("Test")

func _on_detector_body_entered(body) -> void:
	if body.name == 'TileMap':
		under_terrain = true 

func _on_detector_body_exited(body) -> void:
	if body.name == 'TileMap':
		under_terrain = false
