extends Marker3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var radius = 100
var origPos:Vector3

func moveTarget():
	var new_target = Vector3(randf_range(-30, 30), randf_range(20, 80), randf_range(-30, 30))
	global_transform.origin = new_target
	
	print("position change!", global_transform.origin)


# Called when the node enters the scene tree for the first time.
func _ready():
	origPos = global_transform.origin
	moveTarget()


func _on_Timer_timeout():
	moveTarget()


func _on_timer_timeout() -> void:
	moveTarget()
	pass # Replace with function body.
