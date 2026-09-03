extends Node3D

@export var drag : Node
@export var default : Node3D
@export var spawner : Node3D
@export var aud : AudioStreamPlayer3D


func _on_area_entered(area: Area3D) -> void:
	if(area.is_in_group("targetPrio2")):
		drag.target = default
		area.get_parent().queue_free()
		spawner.spawns = 0
		aud.play()
		print("eat sheep!")
	pass 
