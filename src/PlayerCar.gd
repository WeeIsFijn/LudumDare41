extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var velocity
var acceleration
var rotation_velocity
var is_drifting
var turning_time
var drift_velocity

var drift_v_x
var drift_v_y

export (int) var MAX_SPEED = 1200
export (int) var MAX_SPEED_REVERSE = 500
export (int) var ACCELERATION = 1500
export (int) var ACCELERATION_BREAK = 2000
export (int) var ACCELERATION_REVERSE = 300
export (int) var ACCELERATION_DRAG = 1300
export (int) var ACCELERATION_DRAG_DRIFT = 10
export (float) var INVERSE_ROTATION_RADIUS = 3.0
export (float) var DRIFT_ROTATION_FACTOR = 1.6
export (float) var DRIFT_UNDERSTEER_FACTOR = 0.35

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	velocity = Vector2()
	is_drifting = false
	drift_velocity = 0
	turning_time = 0
	pass

func calculate_drag():
	if acceleration.y == 0 && velocity.y < -0.1:
		acceleration.y += ACCELERATION_DRAG

func _process(delta):
	acceleration = Vector2()
	rotation_velocity = 0
	
	
	if Input.is_action_pressed("steer_right"):
		rotation_velocity += INVERSE_ROTATION_RADIUS
		turning_time += delta
	if Input.is_action_pressed("steer_left"):
		rotation_velocity -= INVERSE_ROTATION_RADIUS
		turning_time += delta
	if (!Input.is_action_pressed("steer_left") and !Input.is_action_pressed("steer_right")):
		turning_time = 0
	if Input.is_action_pressed("accelerate"):
		acceleration.y -= ACCELERATION
	if Input.is_action_pressed("decelerate"):
		if velocity.y > 0:
			acceleration.y += ACCELERATION_REVERSE
		else:
			acceleration.y += ACCELERATION_BREAK
			
	calculate_drag()

	velocity += acceleration * delta
	velocity.y = clamp(velocity.y, -1 * MAX_SPEED, MAX_SPEED_REVERSE);
	
	if (rotation_velocity == 0):

		if velocity.x < -1 * ACCELERATION_DRAG_DRIFT:
			velocity.x += ACCELERATION_DRAG_DRIFT
		elif velocity.x > ACCELERATION_DRAG_DRIFT:
			velocity.x -= ACCELERATION_DRAG_DRIFT
		else:
			velocity.x = 0

	var effective_velocity = velocity
	
	if (turning_time > 0.3):

		effective_velocity.x = velocity.y * sin(DRIFT_UNDERSTEER_FACTOR)
		effective_velocity.y = velocity.y * cos(DRIFT_UNDERSTEER_FACTOR)
		rotation_velocity *= DRIFT_ROTATION_FACTOR
	
	velocity.x = effective_velocity.x
	

	#print(velocity)
	
	move_local_x(effective_velocity.x * delta)
	move_local_y(effective_velocity.y * delta)
	rotate(rotation_velocity * delta)