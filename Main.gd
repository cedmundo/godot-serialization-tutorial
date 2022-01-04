extends Spatial

const file_name := "user://default.save"
var more_content := preload("res://MoreContent.tscn")
onready var player := $Player

func _input(event):
	if event.is_action_pressed("save"):
		print("Guardando partida ...")
		save_game()
		print("Partida guardada ...")
		
	if event.is_action_pressed("load"):
		print("Cargando partida ...")
		load_game()
		print("Partida cargada ...")
		
	if event.is_action_pressed("insert"):
		print("Insertando contenido ...")
		insert_content()
		print("Contenido insertado ...")
		
func save_game():
	var save_file := File.new()
	assert(save_file.open(file_name, File.WRITE) != FAILED)
	
	var persistent_nodes := get_tree().get_nodes_in_group("persist")
	for node in persistent_nodes:
		var node_data = node.to_data_dict()
		save_file.store_line(to_json(node_data))
		
	save_file.close()
	
func load_game():
	var save_file := File.new()
	assert(save_file.open(file_name, File.READ) != FAILED)
	
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		if "path" in node_data:
			var node = get_tree().get_root().get_node(node_data["path"])
			node.from_data_dict(node_data)
		elif "resource" in node_data:
			var node = load(node_data["resource"]).instance()
			var parent = get_tree().get_root().get_node(node_data["parent"])
			parent.add_child(node)
			node.from_data_dict(node_data)
		else:
			push_error("Objeto desconocido: %s" % str(node_data))

func insert_content():
	var node := more_content.instance()
	add_child(node)
	node.global_transform = player.global_transform
	node.global_transform.origin.y = 5
	
