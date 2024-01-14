extends State
class_name NPCSpeakingState

#character, animator, detector

signal NPC_finished_speaking

var speaking: bool = false
var dialogues_spoken:Array
var actual_dialogue:int = 0

func _ready() -> void:
	dialogues_spoken.resize(character.dialogues.size())
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	set_physics_process(false)

func _enter_state() -> void:
	if dialogues_spoken.size() != 0:
		DialogueManager.show_dialogue_balloon(character.dialogue_resource, character.dialogues[actual_dialogue])
		if actual_dialogue < dialogues_spoken.size() - 1: #1
			dialogues_spoken[actual_dialogue] = true
			actual_dialogue += 1
	else:
		print("ERROR. DIÁLOGOS NO ASIGNADOS CORRECTAMENTE EN LA ARRAY DE RESPUESTAS")


func _on_dialogue_ended(_resource:DialogueResource) -> void:
	Events.set_last_character_spoken_to(character.get_NPC_name())
	NPC_finished_speaking.emit()
