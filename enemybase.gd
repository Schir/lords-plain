extends Node3D
@export var hp : int
@export var pierceEffectiveness : float
@export var bluntEffectiveness : float
@export var slashEffectiveness : float
@export var magicEffectiveness : float

@export var minimumGold : int = 1
@export var maximumGold : int = 10

@onready var animations = $AnimationPlayer

@onready var goldPath = preload("res://gold.tscn")

var has_generated_items : bool = false

enum states { IDLE, ATTACKING, GOT_HIT, DEAD}
var current_state : states = states.IDLE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(check_dead()):
		current_state = states.DEAD
	match current_state:
		states.IDLE:
			animations.play("idle")
		states.GOT_HIT:
			animations.play("damage")
			await animations.animation_finished
			reset_hit()
			
		states.DEAD:
			animations.play("t-pose")
			if(get_rotation().x < PI/2):
				rotate_x(0.05)
			else:
				if(self.scale.x > 0.01):
					fadeout()
				else:
					if(!has_generated_items):
						drop_item()
					self.visible = false
					get_parent().remove_child(self)
	pass


func take_damage(pierce, blunt, slash, magic):
	current_state = states.GOT_HIT
	hp -= ((pierce * pierceEffectiveness) + 
		(blunt * bluntEffectiveness) +
		(slash * slashEffectiveness) + 
		(magic * magicEffectiveness))

func reset_hit():
		current_state = states.IDLE

func check_dead():
	if(hp <= 0):
		return true
	else:
		return false
		
func fadeout():
	self.scale -= Vector3(0.03, 0.03, 0.03)

func drop_item():
	var gold = (load("res://gold.tscn").instantiate())
	get_parent().add_child(gold)
	gold.generate_coins(minimumGold, maximumGold)
	gold.position = position
	gold.set_positions(position)
	
	has_generated_items = true
	pass

func ai_routine():
	pass
