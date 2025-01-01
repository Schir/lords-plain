class_name Weapon

extends InventoryItem

@export var pierce_damage : int
@export var blunt_damage : int
@export var slash_damage : int
@export var magic_damage : int
var can_damage_again : bool = true
var hitbox : Area3D
var collider2 : CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox = $Cube_001/Area3D
	collider = $Cube_001/StaticBody3D/CollisionShape3D1
	collider2 = $Cube_001/Area3D/CollisionShape3D2
	hitbox.body_entered.connect(self.damage)
	hitbox.body_exited.connect(self.allowMoreDamage)
	initialPosition = position
	targetPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func attack():
	$AnimationPlayer.play("Attack")


func damage(area):
	if(can_damage_again):
		var nodeToGet = area.owner
		print(nodeToGet)
		if nodeToGet.has_method("take_damage"):
			nodeToGet.take_damage(pierce_damage, blunt_damage, slash_damage, magic_damage)
		can_damage_again = false
	pass
	
	
func allowMoreDamage(area):
	can_damage_again = true
	var nodeToGet = area.owner
	print(nodeToGet)
	if nodeToGet.has_method("reset_hit"):
		nodeToGet.reset_hit()

func zoom_in(target : Vector3):
	targetPosition = target
	collider.disabled = true
	collider2.disabled = true
	hitbox.body_entered.disconnect(self.damage)
	hitbox.body_exited.disconnect(self.allowMoreDamage)

func zoom_out():
	targetPosition = initialPosition
	change_rotation()
	hitbox.body_entered.connect(self.damage)
	hitbox.body_exited.connect(self.allowMoreDamage)
	collider.disabled = false
	collider2.disabled = false
