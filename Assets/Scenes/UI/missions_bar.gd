extends VBoxContainer

@onready var quests_bar = $"."
@onready var mission = preload("res://Assets/Scenes/UI/mission.tscn")
@onready var secondary_missions = $secondary_missions

func order_missions():
	var main_quest = quests_bar.find_child("Main_Quest")
	if main_quest:
		quests_bar.move_child(main_quest, 0)

func new_main_quest(title, description):
	var main_quest = quests_bar.find_child("Main_Quest")
	if main_quest != null: 
		main_quest.text = name + "\n" + description
	else:
		var new_child = mission.instantiate()
		new_child.text = title + "\n" + description
		new_child.name = "Main_Quest"
		quests_bar.add_child(new_child)
		new_child.owner = quests_bar

func _ready():
	var main_quest: Array
	main_quest = Journal.get_main_quest()
	new_main_quest(main_quest[0], main_quest[1])
	order_missions()

func _on_start_menu_show_main_quest(toggled_on):
	var main_quest = quests_bar.find_child("Main_Quest")
	if main_quest:
		main_quest.visible = toggled_on

func _on_start_menu_show_secondary_quests(toggled_on):
	secondary_missions.visible = toggled_on
