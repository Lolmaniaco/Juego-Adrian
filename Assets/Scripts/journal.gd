extends Node

signal start_main_quest
signal end_main_quest

signal show_new_main_quest
signal erase_main_quest

var main_quest_name: String = ""
var main_quest_description: String = ""

var secondary_quests: Dictionary = {}
var main_quests: Dictionary = {}
var bool_main_quests: Array
var actual_main_quest: int = -1
const main_quests_doc = "res://main_quests_doc.txt"
var keys: Dictionary = {}

var watermelon:int = 0
var mission_0:bool = false

func _ready():
	Events.player_dead.connect(_on_player_dead)
	start_main_quest.connect(_start_main_quest)
	end_main_quest.connect(_end_main_quest)
	
	keys["LV.1"] = false
	
	var file = FileAccess.open(main_quests_doc, FileAccess.READ)
	var iter:int = 0
	while (not file.eof_reached()):
		main_quests[iter] = [file.get_line(), file.get_line()]
		bool_main_quests.append(false)
		iter += 1
	pass

func player_have_key(key_name:String):
	return keys.get(key_name) #it should return false/true

func player_give_key(key_name:String):
	keys[key_name] = true

func add_secondary_mission(key, value):
	if secondary_quests.has(key):
		secondary_quests[key].append(value)
	else:
		secondary_quests[key] = [value]

func _end_main_quest():
	bool_main_quests[actual_main_quest] = true
	erase_main_quest.emit()

func _start_main_quest(index:int):
	var check = true
	
	for i in range(index):
		if bool_main_quests[i] == false:
			check = false
	
	if check:
		actual_main_quest = index
		main_quest_name = main_quests[index][0]
		main_quest_description = main_quests[index][1]
		show_new_main_quest.emit(main_quest_name, main_quest_description)
	else:
		print("Fatal error. Previous main quest not ended correctly.")

func get_secondary_quests():
	return secondary_quests

func _on_player_dead(_value: String):
	mission_0 = false
	watermelon = 0
	actual_main_quest = -1
