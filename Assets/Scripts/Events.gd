extends Node

signal dialogue_ended
signal player_dead
signal open_vent

var crouched:bool = false
var stand_up_when_ready:bool = false
var can_talk:bool = false
var can_hide:bool = false
var player_move:float 
var last_character_spoken:String 

func set_last_character_spoken_to(character:String):
	last_character_spoken = character

func get_last_character_spoken_to():
	return last_character_spoken
