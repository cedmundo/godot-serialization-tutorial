extends Spatial

var file_name := "user://default.save"
var more_content := preload("res://MoreContent.tscn")
onready var player := $Player
onready var main_menu := $MainMenu
onready var button_save := $HUD/ButtonSave

func _input(event):
	if event.is_action_pressed("insert"):
		print("Insertando contenido ...")
		insert_content()
		print("Contenido insertado ...")
		
func _process(_delta):
	button_save.visible = player.can_save
		
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
	if not save_file.file_exists(file_name):
		return
		
	assert(save_file.open(file_name, File.READ) != FAILED)
	
	# Clean current state
	var persistent_nodes = get_tree().get_nodes_in_group("persist")
	for node in persistent_nodes:
		if node.as_resource:
			node.queue_free()
	
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
	

func _on_DeadZone_body_entered(body):
	if body.has_method("kill"):
		body.kill()


func _on_Player_load_last_game():
	load_game()


func _on_SafeZone_body_entered(body):
	if body.has_method("set_can_save"):
		body.set_can_save(true)


func _on_SafeZone_body_exited(body):
	if body.has_method("set_can_save"):
		body.set_can_save(false)


func _on_ButtonSlot1_pressed():
	file_name = "user://slot1.save"
	load_game()
	main_menu.visible = false
	

func _on_ButtonSlot2_pressed():
	file_name = "user://slot2.save"
	load_game()
	main_menu.visible = false
	

func _on_ButtonSlot3_pressed():
	file_name = "user://slot3.save"
	load_game()
	main_menu.visible = false


func _on_ButtonSave_pressed():
	save_game()
