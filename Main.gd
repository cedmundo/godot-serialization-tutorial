extends Spatial

func _input(event):
	if event.is_action_pressed("save"):
		print("Guardando partida ...")
		save_game()
		print("Partida guardada ...")
		
	if event.is_action_pressed("load"):
		print("Cargando partida ...")
		load_game()
		print("Partida cargada ...")

func save_game():
	var save_file := File.new()
	assert(save_file.open("user://default.save", File.WRITE) != FAILED)
	
	var persistent_nodes := get_tree().get_nodes_in_group("persist")
	for node in persistent_nodes:
		var node_data = {
			"path": node.get_path(),
			"pos_x": node.transform.origin.x,
			"pos_y": node.transform.origin.y,
			"pos_z": node.transform.origin.z,
		}
		save_file.store_line(to_json(node_data))
		
	save_file.close()
	
func load_game():
	var save_file := File.new()
	assert(save_file.open("user://default.save", File.READ) != FAILED)
	
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		var node = get_tree().get_root().get_node(node_data["path"])
		node.transform.origin.x = node_data["pos_x"]
		node.transform.origin.y = node_data["pos_y"]
		node.transform.origin.z = node_data["pos_z"]
