extends StaticBody2D

@export var period:float = 5

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

var fire_up = false

func _ready():
	timer.wait_time = period

func _process(_delta):
	if fire_up:
		animation_player.play("fire_up")
		fire_up = false

func _on_timer_timeout():
	fire_up = true

func _on_flames_body_entered(body):
	if not body is Player: return
	
