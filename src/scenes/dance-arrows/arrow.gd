extends Area2D

const DIRECTIONS = {
	0: "ui_right",
	1: "ui_down",
	2: "ui_left",
	3: "ui_up"
}

export var SPEED = 180

signal missed_arrow
signal selfdestroy(arrow)

var direction = 0
var over_target = false

func _ready():
	connect("area_entered", self, "_on_area_entered_self")

func init(direction, pos):
	"""
	Direction: the direction in which the arrow should face. This is a number that is multiplied by 90 degrees, 
	so the numbers from 0 to 3 are possible.
	"""
	self.direction = direction % 4
	
	rotate(deg2rad(90 * self.direction))
	set_position(pos)

func _process(delta):
	set_position(position + Vector2(SPEED * delta, 0))
	
	if position.x > environment.project_resolution.x:
		emit_signal("selfdestroy", self)
		queue_free()
		
	# If the arrow was over the target and now it is not, than the player missed the arrow
	if over_target:
		var still_overlap = false
		
		for area in get_overlapping_areas():
			if area.is_in_group("arrow_target"):
				still_overlap = true
				break
				
		if !still_overlap:
			emit_signal("missed_arrow")
			over_target = false

func get_direction():	
	return DIRECTIONS[direction]
	
func hit():
	var animation_player = $"AnimationPlayer"
	animation_player.play("Hit")
	animation_player.connect("animation_finished", self, "destroy")
	
func destroy(animation):
	queue_free()
	
func _on_area_entered_self(area):
	if area.is_in_group("arrow_target"):
		over_target = true