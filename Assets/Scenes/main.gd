extends Node2D

@onready var player = $World/Player
@onready var main_camera = $World/Camera2D
@onready var start_menu = $UI/start_menu
@onready var death_report = $UI/DeathReport
@onready var quests_box = $UI/QuestsBox

enum {NORMAL, DEATH_REPORT}
var state = NORMAL

var player_name = "Testes"
var last_character_spoken = ""

func _ready():
	player.connect_camera(main_camera)
	Events.player_dead.connect(_on_player_dead)
	Events.dialogue_ended.connect(_on_dialogue_ended)

func _process(_delta):
	match state:
		NORMAL: normal_state()
		DEATH_REPORT: death_report_state()

func normal_state():
	if Input.is_action_just_pressed("Menú"):
		if get_tree().paused == true:
			start_menu.resume_game()
		else:
			start_menu.pause_game()

func death_report_state():
	
	if Input.is_action_just_pressed("ChangeGravity"):
		get_tree().reload_current_scene()

func _on_dialogue_ended(NPC_name:String):
	last_character_spoken = NPC_name

func _on_player_dead(death_cause:String):
	var memories = ""
	match last_character_spoken:
		"Berta": memories = "I kept studying those dark flashes until darkness came for me. Now, I write these memories with my last remains knowing that we won't see each other again, nor our beloved Earth..."
		"Guturu": memories = "Dofus was my only world, my single obsession and I played til millenia reached my last breath. Only then, I could take my sight out of the screen, watching as the world had been devoured by darkness..."
		_: memories = "From ashes you were born and in ashes you'll go back. Embrace your new form, for after your death you will become the herald of the forthcoming dark empire..."
	
	death_cause = death_cause.to_upper()
	var description = ""
	match death_cause:
		"SPIKES": description = "The victim steped into poisoned spikes. Slight cuts injected venom through the blood vessels reaching in a couple of second to the brain, causing instant paralysis and death"
		"FLAMES": description = "Chemical fire caused an instant shock of pain into the body. The victim fell unconscious dying moments later due to repetitive burns."
		_: description = "Fatal Error. Player killed by unknown danger."

	death_report.set_death_report_data(player_name, Time.get_date_dict_from_system(), memories, description)
	death_report.visible = true
	quests_box.visible = false
	state = DEATH_REPORT
