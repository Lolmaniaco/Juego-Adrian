extends CharacterBody2D
class_name NPC

signal speaking_with_player

@export var dialogue_resource: DialogueResource
@export var dialogue_line: String = "start"
@export var NPC_name: String = ""

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hysteresis = $Hysteresis

enum {IDLE, SPEAKING, EXPLAINING, SIDE}
var state = IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_close: bool = false
var player: Player
var speaking: bool = false

func _ready() -> void:
	Events.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_var: String) -> void:
	state = SIDE
	speaking = false

func _process(delta) -> void:
	apply_gravity(delta)
	move_and_slide()

	match state:
		IDLE: idle_state()
		SIDE: side_state()
		SPEAKING: speaking_state()

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func idle_state() -> void:
	animation_player.play("idle")
	if player_close:
		state = SIDE

func side_state() -> void:
	if not player:
		if hysteresis.is_stopped():
			hysteresis.start()
	else:
		hysteresis.stop()
		if position.x - player.position.x > 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		animation_player.play("side")
		
		if Input.is_action_just_pressed("Action"):
			state = SPEAKING
			speaking_with_player.emit(NPC_name)

func speaking_state() -> void:
	if not speaking:
		DialogueManager.show_dialogue_balloon(dialogue_resource)
		speaking = true

func _on_NPC_detector_body_entered(body) -> void:
	if not body is Player: return
	player = body
	player_close = true

func _on_NPC_detector_body_exited(body) -> void:
	if not body is Player: return
	player = null
	player_close = false

func _on_hysteresis_timeout() -> void:
	state = IDLE
