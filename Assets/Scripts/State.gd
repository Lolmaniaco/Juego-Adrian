extends Node
class_name State

@export var SPEED: int = 200
@export var character: CharacterBody2D
@export var animator: AnimationPlayer
@export var detector: Area2D

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

signal state_finished

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
