class_name InventoryItem

extends Node3D

@export var weight : float
var is_rotating : bool = false
var initialPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPosition = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(is_rotating):
		rotate_y(0.1)
	pass


func interact():
	change_rotation()

func change_rotation():
	if(is_rotating):
		is_rotating = false
	else:
		is_rotating = true
