extends Node3D


@export var isLocked = false
@export var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	if(!isLocked):
		if(!isOpen):
			play_open()
		

func play_open():
	$AnimationPlayer.play("CubeAction")
	isOpen = true
