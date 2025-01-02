extends CharacterBody3D

@export var hp : int = 100
@export var stamina : float = 100
var maxStamina : float = 100
@export var inventory : Array[InventoryItem]
@export var gold : int = 0
@export var weight : float = 253 # approximating the weight of a cop

var speed : float = 3
var defaultSpeed : float = 3
var maxSpeed : float = 6
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var checkInFront : bool = false
var RAYDISTANCE : float = 1.0
var OBJECTDISTANCE : float = 0.3
var checkFromMouse : bool = false
enum states {
	NORMAL,
	PICK_UP_ITEM,
	MENU,
	READING
}
var currentState : states = states.NORMAL
var currentItemReference : WorldItem = null
var decreaseStamina : bool = false

@onready var healthbar = $health
@onready var staminabar = $stamina
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_input():
	match(currentState):
		states.NORMAL:
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
			if Input.is_action_just_pressed("run"):
				decreaseStamina = true
				speed = maxSpeed
			if Input.is_action_just_released("run"):
				decreaseStamina = false
				speed = defaultSpeed
			var input_dir = Input.get_vector("strafe_left", "strafe_right", "ui_up", "ui_down")
			if Input.is_action_just_pressed("ui_select"):
				checkInFront = true
			if Input.is_action_just_released("click"):
				checkFromMouse = true
				var cam = $"Camera3D"
			#var input3 = Vector3(-input_dir.x, 0, input_dir.y)
			var forw = transform.basis.z * input_dir.y
			forw.y = 0
			var side = transform.basis.x * input_dir.x
			side.y = 0
			velocity = forw + side
			velocity.y = 0
			velocity = velocity.normalized() * speed
		states.PICK_UP_ITEM:
			if(Input.is_action_just_pressed("ui_accept")):
				if currentItemReference.has_method("get_gold"):
					gold += currentItemReference.get_gold()
				else:
					var itemRef = currentItemReference.get_item()
					inventory.push_back(itemRef)
				currentItemReference.queue_free()
				currentItemReference = null
				currentState = states.NORMAL
				pass
			if(Input.is_action_just_pressed("ui_cancel")):
				currentItemReference.zoom_out()
				currentState = states.NORMAL
				pass
			
			pass

func _physics_process(delta):
	get_input()
	if not is_on_floor():
		velocity.y -= gravity
		rotate_up(delta)
	move_and_slide()
	var screensize = DisplayServer.window_get_size()
	if(checkInFront):
		var cam = $"Camera3D"
		doRaycast(screensize/2)
		checkInFront = false
	if(checkFromMouse):
		var mouse_pos = get_viewport().get_mouse_position()
		doRaycast(mouse_pos)
		checkFromMouse = false
	if(decreaseStamina):
		stamina -= determine_stamina_loss_per_tick()
		staminabar.set_width(stamina)
	else:
		if stamina < maxStamina:
			stamina += 0.5
			staminabar.set_width(stamina)
	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("I collided with ", collision.get_collider().name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rotate_up(delta):
	if(get_rotation().x < 1.3):
		rotate(transform.basis.x, delta)

func doRaycast(position):
	var cam = $"Camera3D"
	var from = cam.project_ray_origin(position)
	var to = from + cam.project_ray_normal(position) * RAYDISTANCE
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to,
	collision_mask, [self])
	var result = space_state.intersect_ray(query)
	print(result)
	if "collider" in result:
		var pth = result.collider.get_path()
		print(pth)
		var node = get_node(pth)
		node = node.owner
		if node.has_method("interact"):
			if(node.has_method("get_equip_status")):
				if(!node.get_equip_status()):
					node.interact()
			else:
				node.interact()
			if node.has_method("zoom_in"):
				if(node.has_method("get_equip_status")):
					if(!node.get_equip_status()):
						var screensize = DisplayServer.window_get_size()
						var from1 = cam.project_ray_origin(screensize/2)
						var to1 = from1 + cam.project_ray_normal(screensize/2) * OBJECTDISTANCE
						to1.y -= 0.1
						node.zoom_in(to1)
						currentState = states.PICK_UP_ITEM
						currentItemReference = node

func sendHP():
	return hp

func determine_stamina_loss_per_tick():
	return weight/250
