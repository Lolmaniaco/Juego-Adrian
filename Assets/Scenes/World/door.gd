@tool
extends StaticBody2D

enum behaviour {AUTOMATIC, MANUAL}
## Set the door either in automatic or in manual mode
@export var DOOR_BEHAVIOUR = behaviour.AUTOMATIC:
	set(v):
		DOOR_BEHAVIOUR = v
		notify_property_list_changed()
var DOOR_SIDE_OPENS:int

## Set a dialogue resource. If one's selected, 'door message' variable appears  
## to set the line from where it's going to be played
var dialogue_resource: DialogueResource:
	set(v):
		dialogue_resource = v
		notify_property_list_changed()
## Title (String) of the line that is going to be played 
var door_message:String

## Set if the door needs a key to be opened. If yes, 'key name' variable will 
## appear to set the name of the key needed to open this door.
var need_key:bool:
	set(v):
		need_key = v
		notify_property_list_changed()
## Name (String) of the key needed.
var key_name:String

@onready var collision_shape_2d = $CollisionShape2D
@onready var opened_door_sprite_left = $OpenedDoorSpriteLeft
@onready var opened_door_sprite_right = $OpenedDoorSpriteRight
@onready var closed_door_sprite = $ClosedDoorSprite
@onready var hysteresis = $Hysteresis

var player_near: bool = false
var door_opened: bool = false
var temp_player: Player = null
var already_opened: bool = false

func _get_property_list():
	var property_list = []
	if DOOR_BEHAVIOUR == behaviour.MANUAL:
		property_list.append({
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "DialogueResource",
			"name": "dialogue_resource",
			"type": TYPE_OBJECT 
		})
		if dialogue_resource != null:
			property_list.append({
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "door_message",
				"type": TYPE_STRING
			})
		property_list.append({
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Left,Right,Both",
			"name": "DOOR_SIDE_OPENS",
			"type": TYPE_INT
		})
		property_list.append({
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "need_key",
			"type": TYPE_BOOL
		})
		if need_key == true:
			property_list.append({
				"hint": PROPERTY_HINT_NONE,
				"hint_string": "null",
				"usage": PROPERTY_USAGE_DEFAULT,
				"name": "key_name",
				"type": TYPE_STRING
			})
	
	return property_list

func _unhandled_input(event):
	if event.is_action_pressed("Action") and player_near:
		if not need_key:
			if door_opened:
				close_door()
			else:
				open_unlocked_door()
		else:
			var got_key = Journal.player_have_key(key_name)
			if got_key == true:
				need_key = false
				DialogueManager.show_dialogue_balloon(dialogue_resource, "have_key")
				open_unlocked_door()
			else:
				DialogueManager.show_dialogue_balloon(dialogue_resource, "havent_key")

func open_unlocked_door():
	if DOOR_SIDE_OPENS == 1:
		if already_opened or temp_player.global_position.x > global_position.x:
			already_opened = true
			open_door("right_side")
		else:
			DialogueManager.show_dialogue_balloon(dialogue_resource, door_message)
	elif DOOR_SIDE_OPENS == 0:
		if already_opened or temp_player.global_position.x < global_position.x: 
			already_opened = true
			open_door("left_side")
		else:
			DialogueManager.show_dialogue_balloon(dialogue_resource, door_message)
	else:
		if temp_player.global_position.x > global_position.x:
			open_door("right_side")
		else:
			open_door("left_side")

func open_door(open_from:String):
	closed_door_sprite.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	door_opened = true
	need_key = false
	if open_from == "right_side":
		opened_door_sprite_left.visible = true
	else:
		opened_door_sprite_right.visible = true

func close_door():
	closed_door_sprite.visible = true
	collision_shape_2d.set_deferred("disabled", false)
	door_opened = false
	if opened_door_sprite_left.is_visible_in_tree():
		opened_door_sprite_left.visible = false
	else:
		opened_door_sprite_right.visible = false

func deactivate_door():
	if collision_shape_2d.disabled == true:
		collision_shape_2d.set_deferred("disabled", false)
	else:
		collision_shape_2d.set_deferred("disabled", true)

func _on_area_2d_body_entered(body):
	if not body is Player: return
	temp_player = body
	if DOOR_BEHAVIOUR == behaviour.AUTOMATIC:
		hysteresis.stop()
		if DOOR_SIDE_OPENS == 1:
			if temp_player.global_position.x > global_position.x:
				open_door("right_side")
		elif DOOR_SIDE_OPENS == 0:
			if temp_player.global_position.x < global_position.x:
				open_door("left_side")
		else:
			if temp_player.global_position.x < global_position.x:
				open_door("left_side")
			else:
				open_door("right_side")
	else:
		player_near = true

func _on_area_2d_body_exited(body):
	if not body is Player: return
	temp_player = null
	if DOOR_BEHAVIOUR == behaviour.AUTOMATIC:
		if hysteresis.is_stopped():
			hysteresis.start()
	else:
		player_near = false

func _on_hysteresis_timeout():
	close_door()
