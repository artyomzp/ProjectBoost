extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var trust: float = 1000.0

## How much torque force to apply when moving
@export var torque_trust: float = 100.0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * trust)
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, torque_trust * delta))
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -torque_trust * delta))


func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		complete_level()
	if "Hazard" in body.get_groups():
		crash_sequence()
		
func crash_sequence() -> void:
	print("Lose")
	get_tree().reload_current_scene()
	
func complete_level() -> void:
	print("Win")
	get_tree().quit()
	
	
	
