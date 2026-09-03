extends Node

@export var env: Environment
var camera: CameraFeed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.request_permission("Camera")
	print("cameras:")
	CameraServer.monitoring_feeds = true
	for feed in CameraServer.feeds():
		var camname = feed.get_name()
		print(camname)
		
		print(feed.get_id())
		print(feed.get_position())
		
		if(camera == null):
			camera = feed
			
			var camform = camera.get_formats()
			
			camera.set_format(0, camform[1])
			print("format set to ", camform[1])
			camera.feed_is_active = true
			print(camera.get_datatype())
			CameraServer.add_feed(camera)
			
	
	
	if camera == null:
		print("no matching camera found")
		return
		
	print("using camera ", camera.get_name(), camera.get_id())
	print(CameraServer.get_feed_count())
	
	
