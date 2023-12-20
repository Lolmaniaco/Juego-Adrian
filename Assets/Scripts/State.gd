extends Node
class_name State

@export var SPEED: int = 200
@export var player: Player
@export var animator: AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal state_finished

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	pass
