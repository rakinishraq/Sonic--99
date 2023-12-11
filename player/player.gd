extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROLL_SPEED = 1.5
const PITCH_SPEED = 1.0
var rotation_x = 0.0
var rotation_z = 0.0

func _physics_process(delta):
	var tilt_left_strength = Input.get_action_strength("tilt_left")
	var tilt_right_strength = Input.get_action_strength("tilt_right")
	var tilt_up_strength = Input.get_action_strength("tilt_up") * 0.7
	var tilt_down_strength = Input.get_action_strength("tilt_down")

	var target_rotation_x = ROLL_SPEED * (tilt_left_strength - tilt_right_strength)
	var target_rotation_z = PITCH_SPEED * (tilt_up_strength - tilt_down_strength)

	rotation_x = lerp(rotation_x, target_rotation_x, 0.05)
	rotation_z = lerp(rotation_z, target_rotation_z, 0.1)

	rotate_object_local(Vector3(1, 0, 0), rotation_x * delta)
	rotate_object_local(Vector3(0, 0, 1), rotation_z * delta)

	velocity = transform.basis * Vector3.LEFT * 10

	move_and_slide()