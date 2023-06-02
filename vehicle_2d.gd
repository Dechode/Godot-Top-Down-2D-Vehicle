class_name Vehicle2D
extends RigidBody2D

@export var max_steer_angle := 30.0

var throttle := 0.0
var brake := 0.0
var steering := 0.0

var forward_force := 50000.0

@onready var wheel_fr = $WheelFR as Wheel2D
@onready var wheel_fl = $WheelFL as Wheel2D
@onready var wheel_br = $WheelBR as Wheel2D
@onready var wheel_bl = $WheelBL as Wheel2D
@onready var wheels := [$WheelFR,
						$WheelFL,
						$WheelBR,
						$WheelBL]


func _process(delta: float) -> void:
	throttle = Input.get_action_strength("throttle")
	brake = Input.get_action_strength("brake")
	steering = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")


func _physics_process(delta: float) -> void:
	var longitudinal_input = throttle - brake
	var driving_wheels := []
	
	for wheel in wheels:
		if wheel.steering:
			wheel.rotation = steering * deg_to_rad(max_steer_angle)
		if wheel.traction:
			driving_wheels.append(wheel)
	
	for wheel in driving_wheels:
		var force: Vector2 = wheel.global_transform.y * (forward_force * longitudinal_input / driving_wheels.size())
		apply_force(force, wheel.global_position - global_position)
