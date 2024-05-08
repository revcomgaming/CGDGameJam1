extends Area2D
signal hit

var currDist
var totalDist
var facingModifier
var isPlayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	currDist = 0
	if isPlayer:
		name = "Player Arrow" 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if facingModifier == null:
		facingModifier = 1
	if totalDist != null:
		position.x += delta * 500 * facingModifier
		currDist += delta * 500
		if currDist >= totalDist:
			queue_free()

func SetFacingModifier(setFacingModifier):
	facingModifier = setFacingModifier

func SetTotalDistance(setDist):
	totalDist = setDist
	
func IsPlayer():
	isPlayer = true
	set_collision_layer(2)
	
func Destroy():
	queue_free()
