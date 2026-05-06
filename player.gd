extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var trust: float = 1000.0

## How much torque force to apply when moving
@export var torque_trust: float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketEngine
@onready var boost_particles: GPUParticles3D = $BoosterParticles
@onready var right_boost_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_boost_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

var is_transitioning: bool = false

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * trust)
		boost_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		rocket_audio.stop()
		boost_particles.emitting = false
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, torque_trust * delta))
		right_boost_particles.emitting = true
	else:
		right_boost_particles.emitting = false
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -torque_trust * delta))
		left_boost_particles.emitting = true
	else:
		left_boost_particles.emitting = false


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
			
		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	print("Lose")
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	explosion_particles.emitting = true
	
func complete_level(next_level_file: String) -> void:
	print("Win")
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
	success_particles.emitting = true
	
	
	
