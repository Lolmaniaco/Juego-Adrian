extends Node
class_name State

@export var SPEED: int = 200
@export var character: CharacterBody2D
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

func handle_player_crouching(ut:bool = false):
	if Input.is_action_just_pressed("Crouch"):
		animator.play("duck_down")
		Events.crouched = true
	if Input.is_action_just_released("Crouch"):
		Events.stand_up_when_ready = true
	
	if Events.stand_up_when_ready and not ut:
		Events.stand_up_when_ready = false
		animator.play("duck_up")
		Events.crouched = false
