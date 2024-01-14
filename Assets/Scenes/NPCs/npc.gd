extends CharacterBody2D
class_name NPC

signal speaking_with_player

@export var NPC_Name:String
@export var dialogue_resource: DialogueResource
@export var dialogues:Array = []

@onready var FSM = $FiniteStateMachine as FiniteStateMachine
@onready var npc_idle_state = $FiniteStateMachine/NPCIdleState as NPCIdleState
@onready var npc_speaking_state = $FiniteStateMachine/NPCSpeakingState as NPCSpeakingState

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speaking: bool = false

func _ready() -> void:
	npc_idle_state.NPC_started_speaking.connect(FSM.change_state.bind(npc_speaking_state))
	 
	npc_speaking_state.NPC_finished_speaking.connect(FSM.change_state.bind(npc_idle_state))

func _process(delta) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func get_NPC_name():
	return NPC_Name
