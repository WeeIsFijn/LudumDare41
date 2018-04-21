extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var velocity
var acceleration
var rotation_velocity
var is_drifting
var drift_velocity

export (int) var MAX_SPEED = 700
export (int) var MAX_SPEED_REVERSE = 50
export (int) var ACCELERATION = 400
export (int) var ACCELERATION_BREAK = 800
export (int) var ACCELERATION_REVERSE = 20
export (int) var ACCELERATION_DRAG = 200
export (float) var INVERSE_ROTATION_RADIUS = 2.5
export (int) var DRIFT_SPEED_START = 600
export (int) var DRIFT_SPEED_STOP = 500

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	velocity = Vector2()
	is_drifting = false
	drift_velocity = 0
	pass

func calculate_drag():
	if acceleration.y == 0 && velocity.y < -0.1:
		acceleration.y += ACCELERATION_DRAG

func calculate_drift():
	if (drift_velocity == 0):
		## Player is not drifing
		if (-1 * velocity.y > DRIFT_SPEED_START):
			## Start to drift
			print("Start drift")
			drift_velocity = sign(rotation_velocity) * velocity.y 
	
	else:
		## Player is drifting
		print("drift stop?")
		print(-1 * velocity.y)
		if (-1 * velocity.y < DRIFT_SPEED_STOP):
			# Stop to drift
			print("Stop drift")
			drift_velocity = 0
		else:
			## Continue to drift
			drift_velocity = drift_velocity * 0.9
			print("Drift velocity:")
			print(drift_velocity)
	
	velocity.x = drift_velocity
	
	


func _process(delta):
	acceleration = Vector2()
	rotation_velocity = 0
	
	if Input.is_action_pressed("ui_right"):
		rotation_velocity += INVERSE_ROTATION_RADIUS
	if Input.is_action_pressed("ui_left"):
		rotation_velocity -= INVERSE_ROTATION_RADIUS
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= ACCELERATION
	if Input.is_action_pressed("ui_down"):
		if velocity.y > 0:
			acceleration.y += ACCELERATION_REVERSE
		else:
			acceleration.y += ACCELERATION_BREAK
	
	calculate_drag()

	velocity += acceleration * delta
	velocity.y = clamp(velocity.y, -1 * MAX_SPEED, MAX_SPEED_REVERSE);
	
	calculate_drift()
	
	move_local_x(velocity.x * delta)
	move_local_y(velocity.y * delta)
	rotate(rotation_velocity * delta)
	
	pass
