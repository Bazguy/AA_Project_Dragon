extends Marker3D


var origPos:Vector3

func moveTarget():
	var new_target = Vector3(randf_range(-7, 7), randf_range(5, 15), randf_range(-7, 7))
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


func _on_area_3d_area_entered(area: Area3D) -> void:
	if(area.is_in_group("boidDragon")):
		moveTarget()
	
	pass # Replace with function body.
