extends Node

signal start_main_quest
signal update_quests

var main_quest_name: String = ""
var main_quest_description: String = ""

var secondary_quests: Dictionary = {}
var main_quests: Dictionary = {}
var actual_main_quest: int = -1
const main_quests_doc = "res://main_quests_doc.txt"

var watermelon:int = 0
var mission_0:bool = false

func _ready():
	Events.player_dead.connect(_on_player_dead)
	start_main_quest.connect(update_main_quest)
	var file = FileAccess.open(main_quests_doc, FileAccess.READ)
	var iter:int = 0
	while (not file.eof_reached()):
		main_quests[iter] = [file.get_line(), file.get_line()]
		iter += 1

func _on_player_dead():
	mission_0 = false
	watermelon = 0
	actual_main_quest = -1

func add_secondary_mission(key, value):
	if secondary_quests.has(key):
		secondary_quests[key].append(value)
	else:
		secondary_quests[key] = [value]

func update_main_quest(index:int):
	if actual_main_quest < index:
		actual_main_quest = index
		main_quest_name = main_quests[index][0]
		main_quest_description = main_quests[index][1]
		update_quests.emit(main_quest_name, main_quest_description)

func get_secondary_quests():
	return secondary_quests
