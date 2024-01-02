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
		SPEAKING: speaking_state()

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func speaking_state() -> void:
	if not speaking:
		DialogueManager.show_dialogue_balloon(dialogue_resource)
		speaking = true

func _on_hysteresis_timeout() -> void:
	state = IDLE
