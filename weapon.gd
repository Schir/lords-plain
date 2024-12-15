class_name Weapon

extends InventoryItem

@export var pierce_damage : int
@export var blunt_damage : int
@export var slash_damage : int
@export var magic_damage : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hitbox = $Area3D
	hitbox.connect("body_entered", self, "damage")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func attack():
	$AnimationPlayer.play("Attack")


func damage(area):
	print(area)
	pass
