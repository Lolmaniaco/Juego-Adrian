extends Control

@onready var player_name = %PlayerName
@onready var player_death_date = %PlayerDeathDate
@onready var death_description = %DeathDescription
@onready var character_memories = %CharacterMemories

func set_death_report_data(title: String, date: Dictionary, memories: String, description: String):
	player_name.text = title
	player_death_date.text = str(date.day) + "/" + str(date.month) + "/" + str(date.year + 100)
	character_memories.text = "Last memories: " + memories
	death_description.text = "Cause of death: " + description

