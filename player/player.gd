extends CharacterBody3D

const ROLL_SPEED = 1.5 # left/right
const PITCH_SPEED = 1.0 # up/down
var roll_velocity = 0.0
var pitch_velocity = 0.0
var speed = 5.0

func _physics_process(delta):
	var tilt_left_strength = Input.get_action_strength("tilt_left")
	var tilt_right_strength = Input.get_action_strength("tilt_right")
	var tilt_up_strength = Input.get_action_strength("tilt_up") * 0.7
	var tilt_down_strength = Input.get_action_strength("tilt_down")
	var accelerate_strength = Input.get_action_strength("accelerate")
	var decelerate_strength = Input.get_action_strength("decelerate") * 2

	var roll_target = ROLL_SPEED * (tilt_right_strength - tilt_left_strength)
	var pitch_target = PITCH_SPEED * (tilt_up_strength - tilt_down_strength)

	roll_velocity = lerp(roll_velocity, roll_target, 0.05)
	pitch_velocity = lerp(pitch_velocity, pitch_target, 0.05)

	speed += (accelerate_strength - decelerate_strength) * delta
	speed = max(speed, 0)

	rotate_object_local(Vector3.FORWARD, roll_velocity * delta)
	rotate_object_local(Vector3.LEFT, pitch_velocity * delta)

	velocity = -transform.basis.z * speed

	var current_fov = float($Camera3D.fov)
	if accelerate_strength > decelerate_strength:
		$Camera3D.fov = lerp(current_fov, 83.0, 0.005)
	elif decelerate_strength > accelerate_strength:
		$Camera3D.fov = lerp(current_fov, 68.0, 0.005)
	else:
		$Camera3D.fov = lerp(current_fov, 75.0, 0.005)

	move_and_slide()

	var rounded = round(speed * 10) / 10.0
	$CanvasLayer/RichTextLabel1.set_text("[center]"+str(rounded))
	$CanvasLayer/TextureRect.rotation_degrees = rad_to_deg(rotation.z)


var xr_interface: XRInterface
	
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")