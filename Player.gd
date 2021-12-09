extends KinematicBody

export(float) var gravity := 0.98
export(float) var speed := 5.0

var velocity := Vector3.ZERO

func _process(_delta):
	velocity.z = -(Input.get_action_strength("forward") - Input.get_action_strength("backward")) * speed
	velocity.x = -(Input.get_action_strength("left") - Input.get_action_strength("right")) * speed
	
	if is_on_floor():
		velocity.y = -0.1
	else:
		velocity.y -= gravity

	velocity = move_and_slide(velocity, Vector3.UP)
