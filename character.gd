extends CharacterBody3D

@export var hp : int = 100
@export var stamina : float = 100
@export var inventory : Array[InventoryItem]
@export var gold : int = 0

var speed : float = 4
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var checkInFront : bool = false
var RAYDISTANCE : float = 0.85
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_input():
	var rot = get_rotation()
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.1)
	if Input.is_action_pressed("ui_right"):
		rotate_y(-0.1)	
	if Input.is_action_pressed("look_up"):
		rotate_up(0.1)
	if Input.is_action_pressed("look_down"):
		if(rot.x > -1.0):
			rotate(transform.basis.x, -0.1)
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("ui_select"):
		checkInFront = true
	#var input3 = Vector3(-input_dir.x, 0, input_dir.y)
	var forw = transform.basis.z * input_dir.y
	forw.y = 0
	var side = transform.basis.x * input_dir.x
	side.y = 0
	velocity = forw + side
	velocity.y = 0
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	if not is_on_floor():
		velocity.y -= gravity
		rotate_up(delta)
	move_and_slide()
	var screensize = DisplayServer.window_get_size()
	if(checkInFront):
		var cam = $"Camera3D"
		var from = cam.project_ray_origin(screensize/2)
		var to = from + cam.project_ray_normal(screensize/2) * RAYDISTANCE
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to,
		collision_mask, [self])
		var result = space_state.intersect_ray(query)
		print(result)
		if "collider" in result:
			var pth = result.collider.get_path()
			print(pth)
			var node = get_node(pth)
			node = node.get_parent().get_parent()
			if node.has_method("interact"):
				node.interact()
		checkInFront = false
	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("I collided with ", collision.get_collider().name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rotate_up(delta):
	if(get_rotation().x < 1.3):
		rotate(transform.basis.x, delta)
