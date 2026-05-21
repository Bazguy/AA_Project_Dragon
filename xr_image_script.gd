extends Node

var camera_texture: CameraTexture = CameraTexture.new()
var _feed: CameraFeed = null
var _format_ready: bool = false

func _ready() -> void:
	# Request permissions if needed (only on Android / Quest)
	if not _has_permissions():
		OS.request_permissions()
		get_tree().on_request_permissions_result.connect(_on_permission_result)
	else:
		_setup_camera()

func _has_permissions() -> bool:
	if OS.get_name() == "Android":
		var granted := OS.get_granted_permissions()
		return granted.has("android.permission.CAMERA") and granted.has("horizonos.permission.HEADSET_CAMERA")
	return true  # not Android, assume fine

func _on_permission_result(_permission: String, granted: bool) -> void:
	if granted and _has_permissions():
		_setup_camera()


 func _setup_camera() -> void:
	CameraServer.monitoring_feeds = true
	var feeds := CameraServer.feeds()
	
	# On Quest, passthrough feeds are at index 1 (left eye) and 2 (right eye)
	if feeds.size() < 3:
		printerr("Not enough camera feeds – are permissions granted?")
		return
	
	_feed = feeds[1]   # left passthrough eye
	
	_feed.frame_changed.connect(_on_frame_changed)
	_feed.format_changed.connect(_on_format_changed)
	
	# Highest resolution format
	var formats := _feed.formats
	var best_idx := 0
	var max_w := 0
	for i in formats.size():
		if formats[i].width > max_w:
			max_w = formats[i].width
			best_idx = i
	_feed.set_format(best_idx, formats[best_idx])
	_feed.feed_is_active = true

func _on_frame_changed() -> void:
	if not _format_ready or camera_texture == null:
		return
	var img := camera_texture.get_image()
	if img:
		print("Passthrough frame size: ", img.get_size())
		# Here you can process the image
	else:
		print("Frame changed but image is null")

func _on_format_changed() -> void:
	if _format_ready:
		return
	_format_ready = true
	camera_texture.camera_feed_id = _feed.get_id()
	print("Camera format ready – receiving frames.")
