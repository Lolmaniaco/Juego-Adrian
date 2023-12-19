extends ColorRect

@onready var start_menu = $"."
@onready var main_menu = $main_menu
@onready var confirm_quit = $main_menu/confirm_quit
@onready var options_menu = $options_menu
@onready var menu = $main_menu/menu

signal show_main_quest
signal show_secondary_quests

func _ready():
	start_menu.visible = false

func pause_game():
	start_menu.visible = true
	get_tree().paused = true

func resume_game():
	start_menu.visible = false
	_on_no_pressed()
	_on_back_pressed()
	get_tree().paused = false

func _on_resume_pressed():
	resume_game()

func _on_exit_pressed():
	confirm_quit.visible = true
	menu.visible = false

func _on_no_pressed():
	confirm_quit.visible = false
	menu.visible = true

func _on_yes_pressed():
	get_tree().quit()

func _on_options_pressed():
	main_menu.visible = false
	options_menu.visible = true

func _on_back_pressed():
	main_menu.visible = true
	options_menu.visible = false

func _on_secondary_quests_toggled(toggled_on):
	show_secondary_quests.emit(toggled_on)

func _on_main_quest_toggled(toggled_on):
	show_main_quest.emit(toggled_on)
