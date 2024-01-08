extends CharacterBody2D


const SPEED = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.LEFT

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity = direction * SPEED
	var collision = move_and_slide()
	
	if collision:
		if direction == Vector2.LEFT:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
