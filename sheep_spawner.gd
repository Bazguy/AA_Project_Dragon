extends Node3D

var sheep = preload("res://sheeeep.tscn")

var spawns : int = 0




func _on_timer_timeout() -> void:
	if(spawns < 1):
		spawns = spawns + 1
		var instance = sheep.instantiate()
		add_child(instance)
		var new_target = Vector3(randf_range(-15, 15), 1, randf_range(-15, 15))
		global_transform.origin = new_target
	pass # Replace with function body.
