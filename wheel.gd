class_name Wheel2D
extends Marker2D

#@export var wheel_inertia = 1.2
#@export var radius := 0.3

@export var traction := false
@export var steering := false

# For some reason has to be set high or it would have very little friction
@export var friction := 3.0

var prev_pos := Vector2.ZERO
var peak_slip_angle := 0.1
var peak_slip_ratio := 0.07
var spin := 0.0

var lat_force := 0.0
var long_force := 0.0

@onready var car := get_parent() as RigidBody2D


func _physics_process(delta: float) -> void:
	var local_vel := (global_position - prev_pos).rotated(global_rotation)
	var planar_vec := Vector2(local_vel.x, local_vel.y).normalized()
	var slip_angle := (global_position - prev_pos).angle_to(global_transform.y)
	var slip_angle_factor: float = abs(slip_angle) / peak_slip_angle
	
	lat_force = clamp(slip_angle_factor, -1, 1) * car.mass * sign(slip_angle) * friction
	# Longitudinal force is handled by the vehicle script
	car.apply_force(-lat_force * global_transform.x, global_position - car.global_position)
	
	prev_pos = global_position

