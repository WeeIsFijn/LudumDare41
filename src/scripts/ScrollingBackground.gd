extends Sprite

onready var CarRoot = get_parent().get_node("CarRoot")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	position = CarRoot.position
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
