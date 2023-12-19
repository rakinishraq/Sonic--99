extends CharacterBody3D

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROLL_SPEED = 1.5
const PITCH_SPEED = 1.0
var speed = BASE_SPEED
var rotation_z = 0.0
var rotation_y = 0.0

func _physics_process(delta):
	var tilt_left_strength = Input.get_action_strength("tilt_left")
	var tilt_right_strength = Input.get_action_strength("tilt_right")
	var tilt_up_strength = Input.get_action_strength("tilt_up") * 0.7
	var tilt_down_strength = Input.get_action_strength("tilt_down")
	var accelerate_strength = Input.get_action_strength("accelerate")
	var decelerate_strength = Input.get_action_strength("decelerate") * 2

	var target_rotation_z = ROLL_SPEED * (tilt_left_strength - tilt_right_strength)
	var target_rotation_y = PITCH_SPEED * (tilt_down_strength - tilt_up_strength)

	rotation_z = lerp(rotation_z, target_rotation_z, 0.05)
	rotation_y = lerp(rotation_y, target_rotation_y, 0.05)

	speed += (accelerate_strength - decelerate_strength) * delta
	speed = max(speed, 0)

	rotate_object_local(Vector3(0, 0, 1), rotation_z * delta)
	rotate_object_local(Vector3(0, 1, 0), rotation_y * delta)

	velocity = transform.basis.z * speed * -1

	var current_fov = float($Camera3D.fov)
	if accelerate_strength > decelerate_strength:
		$Camera3D.fov = lerp(current_fov, 83.0, 0.005)
	elif decelerate_strength > accelerate_strength:
		$Camera3D.fov = lerp(current_fov, 68.0, 0.005)
	else:
		$Camera3D.fov = lerp(current_fov, 75.0, 0.005)

	move_and_slide()
