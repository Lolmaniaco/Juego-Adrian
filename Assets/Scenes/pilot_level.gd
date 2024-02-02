extends Node2D

@onready var vent = %Vent

func _ready():
	Events.open_vent.connect(open_vent)

func open_vent():
	vent.queue_free()
