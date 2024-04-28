extends Node2D

var currDist = 0
var totalDist
var startPos
var color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	
func SetColor(setColor):
	color = setColor
	
func _draw():
	if currDist > 0 && startPos != null:
		draw_circle(startPos, currDist, color)
