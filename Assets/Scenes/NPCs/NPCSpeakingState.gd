extends State
class_name NPCSpeakingState

#character, animator, detector

signal NPC_finished_speaking

var speaking: bool = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	set_physics_process(false)

func _enter_state() -> void:
	DialogueManager.show_dialogue_balloon(character.dialogue_resource)
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _on_dialogue_ended(_resource:DialogueResource) -> void:
	Events.set_last_character_spoken_to(character.get_NPC_name())
	NPC_finished_speaking.emit()
