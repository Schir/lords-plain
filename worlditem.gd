class_name WorldItem

extends Node3D

@export var item : InventoryItem
var is_rotating : bool = false
var initialPosition : Vector3
var targetPosition : Vector3
var zoomBool :bool = false
var collider : CollisionShape3D
@export var isEquipped : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(is_rotating):
		rotate_y(0.1)
	if(targetPosition != position):
		position = position.lerp(targetPosition, 0.3)
	pass


func interact():
	change_rotation()

func change_rotation():
	if(is_rotating):
		is_rotating = false
	else:
		is_rotating = true
		
func zoom_in(target : Vector3):
	targetPosition = target
	collider.disabled = true

func zoom_out():
	targetPosition = initialPosition
	collider.disabled = false
	change_rotation()
	
func set_positions(target : Vector3):
	initialPosition = target
	targetPosition = target

func get_item():
	return item

func get_equip_status():
	return isEquipped
