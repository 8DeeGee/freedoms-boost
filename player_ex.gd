extends RigidBody3D

##Super Destroyer's applied vertical thrust
@export_range(750.0, 3000.0) var thrust: float = 1000.0
##Super Destroyer's applied rotational force
@export var yaw: float = 100.0

@onready var explosion_audio: AudioStreamPlayer3D = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var thruster_audio: AudioStreamPlayer3D = $ThrusterAudio

@onready var main_thruster_particles: GPUParticles3D = $MainThrusterParticles
@onready var right_thruster_particles: GPUParticles3D = $RightThrusterParticles
@onready var left_thruster_particles: GPUParticles3D = $LeftThrusterParticles

@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

@onready var trauma_causer: Area3D = $"Trauma Causer"

var is_changing_state: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		main_thruster_particles.emitting = true
		if thruster_audio.playing == false:
			thruster_audio.play()
	else:
		thruster_audio.stop()
		main_thruster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, yaw * delta))
		right_thruster_particles.emitting = true
	else:
		right_thruster_particles.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -yaw * delta))
		left_thruster_particles.emitting = true
	else:
		left_thruster_particles.emitting = false
		
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_body_entered(body: Node) -> void:
	if !is_changing_state:
		if body.is_in_group("Goal"):	
			complete_level(body.file_path)

		if body.is_in_group("Hazard"):
			crash_sequence()
		
func crash_sequence() -> void:
	print("Ouchie!")
	explosion_particles.emitting = true
	explosion_audio.play()
	thruster_audio.stop()
	main_thruster_particles.emitting = false
	right_thruster_particles.emitting = false
	left_thruster_particles.emitting = false
	trauma_causer.cause_trauma()
	
	set_process(false)
	is_changing_state = true
	
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().reload_current_scene)
	
func complete_level(next_level_path: String) -> void:
	print("You win!")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_changing_state = true
	
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_path))
	
