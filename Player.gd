extends KinematicBody

signal load_last_game()

export(float) var gravity := 0.98
export(float) var speed := 5.0
export(float) var jump_power := 20.0
export(int) var selected_color := 0
export(Array, Color) var available_colors := [
	Color.yellowgreen,
	Color.turquoise,
	Color.tan,
	Color.salmon
]

var can_save := false
var as_resource := false
var velocity := Vector3.ZERO
onready var mesh_instance := $MeshInstance
onready var safe_zone_label := $SafeZoneLabel

func _ready():
	_change_color()
	
func _change_color():
	var material = mesh_instance.get_surface_material(0)
	material.albedo_color = available_colors[selected_color % available_colors.size()]
	mesh_instance.set_surface_material(0, material)

func _process(_delta):
	velocity.z = -(Input.get_action_strength("forward") - Input.get_action_strength("backward")) * speed
	velocity.x = -(Input.get_action_strength("left") - Input.get_action_strength("right")) * speed
	
	if is_on_floor():
		velocity.y = -0.1
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_power
	else:
		velocity.y -= gravity

	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("change_color"):
		selected_color += 1
		_change_color()
		
	if can_save:
		safe_zone_label.text = "Presiona F1 para guardar"
	else:
		safe_zone_label.text = ""

func to_data_dict():
	return {
		"path": get_path(),
		"selected_color": selected_color,
		"pos": PersistentObject.encode_vec3(global_transform.origin)
	}

func from_data_dict(data):
	selected_color = data["selected_color"]
	global_transform.origin = PersistentObject.decode_vec3(data["pos"])
	_change_color()

func set_can_save(v):
	can_save = v

func kill():
	emit_signal("load_last_game")

