extends StaticBody2D

enum behaviour {AUTOMATIC, MANUAL}
@export var DOOR_BEHAVIOUR = behaviour.AUTOMATIC

@onready var collision_shape_2d = $CollisionShape2D
@onready var opened_door_sprite_left = $OpenedDoorSpriteLeft
@onready var opened_door_sprite_right = $OpenedDoorSpriteRight
@onready var closed_door_sprite = $ClosedDoorSprite
@onready var hysteresis = $Hysteresis

var player_near: bool = false
var door_opened: bool = false
var temp_player = null

func _process(_delta):
	if DOOR_BEHAVIOUR == behaviour.AUTOMATIC: return
	if Input.is_action_just_pressed("Action") and player_near:
		if door_opened:
			close_door()
		else:
			open_door()

func open_door():
	door_opened = true
	closed_door_sprite.visible = false
	if temp_player.position.x > position.x:
		opened_door_sprite_left.visible = true
	else:
		opened_door_sprite_right.visible = true
	collision_shape_2d.set_deferred("disabled", true)

func close_door():
	door_opened = false
	closed_door_sprite.visible = true
	opened_door_sprite_left.visible = false
	opened_door_sprite_right.visible = false
	collision_shape_2d.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if not body is Player: return
	temp_player = body
	if DOOR_BEHAVIOUR == behaviour.AUTOMATIC:
		hysteresis.stop()
		if door_opened == false:
			open_door()
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
