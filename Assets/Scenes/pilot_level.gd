extends Node2D

@onready var vent = $World/Vent
@onready var tile_map = $World/TileMap

func _ready():
	Events.open_vent.connect(open_vent)

func open_vent():
	tile_map.set_layer_modulate(1,"00f400") #GREEN
	vent.visible = false
	vent.deactivate_door()
	
	await get_tree().create_timer(10).timeout
	tile_map.set_layer_modulate(1,"ff0000") #RED
	vent.visible = true
	vent.deactivate_door()
