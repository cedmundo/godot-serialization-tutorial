extends Spatial

export(bool) var as_resource := false
export(String) var resource_name := ""

func encode_vec3(v: Vector3) -> Dictionary:
	return {"x": v.x, "y": v.y, "z": v.z}
	
func decode_vec3(d: Dictionary) -> Vector3:
	return Vector3(d["x"], d["y"], d["z"])

func to_data_dict():
	var data : Dictionary = {
		"pos": encode_vec3(global_transform.origin),
		"rot": {
			"x": encode_vec3(global_transform.basis.x),
			"y": encode_vec3(global_transform.basis.y),
			"z": encode_vec3(global_transform.basis.z),
		}
	}
	
	if as_resource:
		data["resource"] = resource_name
		data["parent"] = get_parent().get_path()
	else:
		data["path"] = get_path()
		
	return data

func from_data_dict(data):
	global_transform.origin = decode_vec3(data["pos"])
	global_transform.basis.x = decode_vec3(data["rot"]["x"])
	global_transform.basis.y = decode_vec3(data["rot"]["y"])
	global_transform.basis.z = decode_vec3(data["rot"]["z"])
