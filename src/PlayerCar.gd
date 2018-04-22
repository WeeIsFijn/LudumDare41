extends KinematicBody2D

var velocity = Vector2()
var turning_time = 0
var powerup_multiplier = 1
var engine_running = false

onready var area = $"Area2D"
onready var AccelerateAudio = $AccelerateAudio
onready var DriftAudio = $DriftAudio
onready var IdleAudio = $IdleAudio

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

signal died

func stop_engine():
	engine_running = false
	AccelerateAudio.stop()
	DriftAudio.stop()
	IdleAudio.stop()

func start_engine():
	engine_running = true
	IdleAudio.play()
	
func calculate_drag(acceleration):
	if acceleration.y == 0 && velocity.y < -0.1:
		acceleration.y += ACCELERATION_DRAG
	return acceleration

func _process(delta):
	if !engine_running:
		return

	var acceleration = Vector2()
	var rotation_velocity = 0
	
	if Input.is_action_pressed("steer_right"):
		rotation_velocity += INVERSE_ROTATION_RADIUS
		turning_time += delta
	if Input.is_action_pressed("steer_left"):
		rotation_velocity -= INVERSE_ROTATION_RADIUS
		turning_time += delta
	if (!Input.is_action_pressed("steer_left") and !Input.is_action_pressed("steer_right")):
		turning_time = 0
	if Input.is_action_pressed("accelerate"):
		acceleration.y -= ACCELERATION * powerup_multiplier
		if (!AccelerateAudio.playing):
			AccelerateAudio.play()
	if !Input.is_action_pressed("accelerate"):
		if (AccelerateAudio.playing):
			AccelerateAudio.stop()
	if Input.is_action_pressed("decelerate"):
		if velocity.y > 0:
			acceleration.y += ACCELERATION_REVERSE * powerup_multiplier
		else:
			acceleration.y += ACCELERATION_BREAK
			
	acceleration = calculate_drag(acceleration)

	velocity += acceleration * delta
	velocity.y = clamp(velocity.y, -MAX_SPEED * powerup_multiplier, MAX_SPEED_REVERSE * powerup_multiplier);
	
	if (rotation_velocity == 0):
		if velocity.x < -ACCELERATION_DRAG_DRIFT * powerup_multiplier:
			velocity.x += ACCELERATION_DRAG_DRIFT * powerup_multiplier
		elif velocity.x > ACCELERATION_DRAG_DRIFT * powerup_multiplier:
			velocity.x -= ACCELERATION_DRAG_DRIFT * powerup_multiplier
		else:
			velocity.x = 0

	var effective_velocity = velocity
	
	if (turning_time > 0.3):
		effective_velocity.x = velocity.y * sin(DRIFT_UNDERSTEER_FACTOR / powerup_multiplier)
		effective_velocity.y = velocity.y * cos(DRIFT_UNDERSTEER_FACTOR / powerup_multiplier)
		
		rotation_velocity *= DRIFT_ROTATION_FACTOR
	
	velocity.x = effective_velocity.x
	
	if (velocity.x != 0):
		if(!DriftAudio.playing):
			DriftAudio.play()
	else:
		if(DriftAudio.playing):
			DriftAudio.stop()

	move_local_x(effective_velocity.x * delta)
	move_local_y(effective_velocity.y * delta)
	rotate(rotation_velocity * delta)
	
	var safe = false
	print("overlapping")
	print(str(area.get_overlapping_bodies()))
	for overlapper in area.get_overlapping_bodies():
		if overlapper.is_in_group("rode"):
			safe = true
	if not safe:
		# spawn explosie
		emit_signal("died")
		velocity = Vector2()
		turning_time = 0
		powerup_multiplier = 1
	
func _on_powerup(multiplier):
	self.powerup_multiplier = multiplier