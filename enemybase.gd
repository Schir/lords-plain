extends Node
@export var hp : int

@onready var animations = $AnimationPlayer

enum states { IDLE, ATTACKING, GOT_HIT}
var current_state : states = states.IDLE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hitbox = $skeleton_rig/Skeleton3D/SkeletonBox
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		states.IDLE:
			animations.play("idle")
		states.GOT_HIT:
			animations.play("damage")
	pass


func take_damage():
	current_state = states.GOT_HIT

func reset_hit():
		current_state = states.IDLE
