extends Node

var main_quest_name: String = ""
var main_quest_description: String = ""
var main_quest_journal: Dictionary = {}
var secondary_quests: Dictionary = {}

func change_main_quest(key, value):
	main_quest_journal[main_quest_name] = main_quest_description
	main_quest_name = key
	main_quest_description = value

func add_secondary_mission(key, value):
	if secondary_quests.has(key):
		secondary_quests[key].append(value)
	else:
		secondary_quests[key] = [value]

func get_main_quest():
	return [main_quest_name, main_quest_description]

func get_secondary_quests():
	return secondary_quests
	
func _ready():
	main_quest_name = "[b] MISIÓN PRINCIPAL [/b]"
	main_quest_description = "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno"
