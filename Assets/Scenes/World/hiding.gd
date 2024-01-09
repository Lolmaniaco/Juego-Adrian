extends Area2D

@onready var remote_transform_2d = $RemoteTransform2D
@onready var collision_polygon = $CollisionPolygon2D
@onready var polygon_2d = $Polygon2D

var temp_player:Player

func _unhandled_input(event):
	if temp_player:
		if event is InputEventKey:
			if event.pressed:
				if event.is_action_pressed("Action"):
					remote_transform_2d.remote_path = temp_player.get_path()
func _ready():
	polygon_2d.polygon = collision_polygon.polygon

func _on_body_entered(body):
	if not body is Player: return
	temp_player = body

func _on_body_exited(body):
	if not body is Player: return
	remote_transform_2d.remote_path = ""
	temp_player = null
