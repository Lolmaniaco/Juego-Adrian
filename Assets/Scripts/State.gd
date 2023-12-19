extends Node
class_name State

@export var SPEED: int = 200
@export var player: Player
@export var animator: AnimationPlayer

signal state_finished

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	pass
