extends StaticBody2D

enum behaviour {AUTOMATIC, MANUAL}
@export var DOOR_BEHAVIOUR = behaviour.AUTOMATIC

enum side {left, right, both}
@export var DOOR_SIDE_OPENS = side.left

@export var dialogue_resource: DialogueResource
@export var door_message:String = ""
@export var need_key:bool = false
@export var key_needed:String = ""

@onready var collision_shape_2d = $CollisionShape2D
@onready var opened_door_sprite_left = $OpenedDoorSpriteLeft
@onready var opened_door_sprite_right = $OpenedDoorSpriteRight
@onready var closed_door_sprite = $ClosedDoorSprite
@onready var hysteresis = $Hysteresis

var player_near: bool = false
var door_opened: bool = false
var temp_player: Player = null
var already_opened: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("Action") and player_near:
		if not need_key:
			if door_opened:
				close_door()
			else:
				open_unlocked_door()
		else:
			var got_key = Journal.player_have_key(key_needed)
			if got_key == true:
				need_key = false
				DialogueManager.show_dialogue_balloon(dialogue_resource, "have_key")
				open_unlocked_door()
			else:
				DialogueManager.show_dialogue_balloon(dialogue_resource, "havent_key")

func open_unlocked_door():
	if DOOR_SIDE_OPENS == side.right:
		if already_opened or temp_player.global_position.x > global_position.x:
			already_opened = true
			open_door("right_side")
		else:
			DialogueManager.show_dialogue_balloon(dialogue_resource, door_message)
	elif DOOR_SIDE_OPENS == side.left:
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
		if DOOR_SIDE_OPENS == side.right:
			if temp_player.global_position.x > global_position.x:
				open_door("right_side")
		elif DOOR_SIDE_OPENS == side.left:
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
