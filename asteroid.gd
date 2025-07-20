extends AnimatableBody3D

@export var destination1: Vector3
@export var destination2: Vector3
@export var destination3: Vector3
@export var duration_depth: float = 1.0
@export var duration_witdh: float = 6.0
@export var rotation_speed: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var move_tween = create_tween()
	move_tween.set_loops()
	#initial movement, moves to the back of scene
	move_tween.tween_property(self, "global_position", global_position + destination1, duration_depth)
	#sideways movement on the back of scene
	move_tween.tween_property(self, "global_position", global_position + destination2, duration_witdh)
	#returns back to the front of the scene
	move_tween.tween_property(self, "global_position", global_position + destination3, duration_depth)
	#returns to it's starting point, using duration_depth to speed up the process
	move_tween.tween_property(self, "global_position", global_position, duration_depth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
	rotate_x((rotation_speed * delta/2))
	rotate_z((rotation_speed * delta/2))
