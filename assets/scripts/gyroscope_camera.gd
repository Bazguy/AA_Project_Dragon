extends Node3D

#This script will detect whether the app is run on a mobile device or pc
#It will then operate either gyro camera controls or mouse camera controls

@export var cam: Node3D
#Gyromovement Vars
var pitch: float = 0.0
var roll: float = 0.0
var yaw: float = 0.0

var initial_yaw : float = 0.0

var k : float = 0.98

var m : bool = false

#Mouse Movement VARS
const SENSITIVITY: float = 0.1

var twist_input: float = 0.0
var pitch_input: float = 0.0


func _ready():
	if(OS.has_feature("mobile")):
		await get_tree().create_timer(0.1).timeout
		var magnet: Vector3 = Input.get_magnetometer()
		print(magnet)
		initial_yaw = atan2(-magnet.x, magnet.z) 
		m = true
		
	else:
		m = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		

func _physics_process(delta):
	
	if(m):
		gyroCam(delta)
	elif(!m):
		mouseCam(delta)
	


func gyroCam(delta):
	var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	gravity = gravity.rotated(-Vector3.FORWARD, rotation.z)
	var pitch_acc = atan2(gravity.z, -gravity.y)
	var yaw_magnet = atan2(-magnet.x, magnet.z)
	
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k)
	yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k) 
	
	cam.rotation = Vector3(pitch, yaw - initial_yaw, roll)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		twist_input -= event.screen_relative.x * SENSITIVITY
		pitch_input -= event.screen_relative.y * SENSITIVITY
		pitch_input = clamp(pitch_input, -85, 85)



func mouseCam(delta):
	print("pc detected!")
	var current_q = basis.get_rotation_quaternion()
	var twist_q = Quaternion(Vector3.UP, deg_to_rad(twist_input))
	var pitch_q = Quaternion(Vector3.RIGHT, deg_to_rad(pitch_input))
	var smoothed_q = current_q.slerp(twist_q * pitch_q, delta * 20.0)
	basis = Basis(smoothed_q)
	
	
