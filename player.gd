extends Node3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		position.y += delta
		
	if Input.is_action_pressed("ui_left"):
		rotate_z(delta)
		
	if Input.is_action_pressed("ui_right"):
		rotate_z(-delta)
