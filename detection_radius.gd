extends Area3D

@export var drag : Node

@export var default: Node3D
var sheep: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_area_entered(area: Area3D) -> void:
	if(area.is_in_group("targetPrio2")):
		drag.target = area
		print("sheeeeeeep!")
		
	
	
	pass # Replace with function body.
