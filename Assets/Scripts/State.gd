extends Node
class_name State

@export var SPEED: int = 200
@export var player: Player
@export var animator: AnimationPlayer
@export var detector: Area2D

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

var under_terrain:bool = false

signal state_finished

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	pass

func handle_player_crouching(under_terrain:bool = false):
	if Input.is_action_just_pressed("KeyDown"):
		animator.play("duck_down")
		Events.crouched = true
	if Input.is_action_just_released("KeyDown"):
		Events.stand_up_when_ready = true
	
	if Events.stand_up_when_ready and not under_terrain:
		Events.stand_up_when_ready = false
		animator.play("duck_up")
		Events.crouched = false
