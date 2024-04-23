extends Area2D

var currDist
var totalDist
var facingModifier

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	currDist = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if facingModifier == null:
		facingModifier = 1
	if totalDist != null:
		position.x += delta * 300 * facingModifier
		currDist += 300
		if currDist >= totalDist:
			queue_free()

func SetFacingModifier(setFacingModifier):
	facingModifier = setFacingModifier

func SetTotalDistance(setDist):
	totalDist = setDist
