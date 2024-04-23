extends Node2D

var currDist
var totalDist
var startPos

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	currDist = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if totalDist != null:
		currDist += delta * 50
		if currDist < totalDist:
			queue_redraw()
		else:
			queue_free()
		
func SetStart(setPos, setDist):
	startPos = setPos
	totalDist = setDist
	
func _draw():
	if currDist > 0 && startPos != null:
		draw_circle(startPos, currDist, Color.RED)
