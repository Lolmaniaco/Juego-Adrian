extends State
class_name PlayerIdleState

signal player_speaking
signal change_gravity

var crouched:bool = false

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")
	if player.velocity.x != 0:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED/10)
 
func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta) -> void:
	if not crouched:
		if not animator.is_playing():
			animator.play("idle")
	
	if Input.is_action_just_pressed("Crouch"):
		animator.play("duck_down")
		crouched = true
	if Input.is_action_just_released("Crouch"):
		animator.play("duck_up")
		crouched = false
