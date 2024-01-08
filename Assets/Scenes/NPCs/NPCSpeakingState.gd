extends State
class_name NPCSpeakingState

#character, animator, detector

signal NPC_finished_speaking

@export var dialogue_resource: DialogueResource

var speaking: bool = false

func _ready() -> void:
	Events.dialogue_ended.connect(_on_dialogue_ended)
	set_physics_process(false)

func _enter_state() -> void:
	Events.player_move = 0
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta):
	if not speaking:
		DialogueManager.show_dialogue_balloon(dialogue_resource)
		speaking = true

func _on_dialogue_ended(_name:String) -> void:
	speaking = false
	NPC_finished_speaking.emit()
