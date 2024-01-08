extends VBoxContainer

@onready var quests_bar = $"."
@onready var mission = preload("res://Assets/Scenes/UI/mission.tscn")
@onready var secondary_missions = $secondary_missions

func _ready():
	Journal.show_new_main_quest.connect(new_main_quest)
	Journal.erase_main_quest.connect(finish_main_quest)

func new_main_quest(title, description):
	var new_child = mission.instantiate()
	new_child.text = title + "\n" + description
	new_child.name = "Main_Quest"
	quests_bar.add_child(new_child)
	new_child.owner = quests_bar

	quests_bar.move_child(quests_bar.find_child("Main_Quest"), 0)

func finish_main_quest():
	var main_quest = quests_bar.find_child("Main_Quest")
	if main_quest:
		main_quest.queue_free()

func _on_start_menu_show_main_quest(toggled_on):
	var main_quest = quests_bar.find_child("Main_Quest")
	if main_quest:
		main_quest.visible = toggled_on

func _on_start_menu_show_secondary_quests(toggled_on):
	secondary_missions.visible = toggled_on
