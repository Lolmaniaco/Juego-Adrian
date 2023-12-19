extends State
class_name PlayerIdleState

signal player_moving
signal player_crouching
signal player_speaking
signal change_gravity

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")
	if player.velocity.x != 0:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED/10)
 
func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if not animator.is_playing():
		animator.play("idle")
