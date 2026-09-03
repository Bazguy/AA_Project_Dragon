extends Control 
@onready var camera : NativeCamera = $NativeCamera

func _ready():
	camera.camera_permission_granted.connect(_on_camera_permission_granted)
	camera.camera_permission_denied.connect(_on_camera_permission_denied)
	camera.frame_available.connect(_on_frame_available)
	camera.request_camera_permission()

func _on_camera_permission_granted() -> void:
	var cameras := camera.get_all_cameras()
	if cameras.is_empty():
		return

	var cam: CameraInfo = cameras[0]
	var request := FeedRequest.new()
	camera.set_camera_id(cam.get_camera_id())
	camera.set_width(1280)
	camera.set_height(720)
	camera.set_rotation(90)
	camera.set_grayscale(false)
	camera.set_mirror_horizontal(true)   # flip left-right (e.g. selfie camera preview)
	camera.set_mirror_vertical(false)
	camera.set_scale_width(640)          # downscale to 640×360 before emitting
	camera.set_scale_height(360)

	camera.start(request)

func _on_camera_permission_denied() -> void:
	push_error("Camera permission denied")

func _on_frame_available(frame: FrameInfo) -> void:
	var img := frame.get_image()
	# Use the image or raw buffer here
