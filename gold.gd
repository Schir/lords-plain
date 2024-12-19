extends MeshInstance3D
@export var gold_value : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	print("it's gold!")
	pass


func generate_coins(min: int, max: int):
	var rng = RandomNumberGenerator.new()
	gold_value = rng.randi_range(min, max)
	pass
