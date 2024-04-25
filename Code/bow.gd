extends Node2D

@export var arrowScene: PackedScene

var arrowMarker
var facingModifier
var isFiring = false
var bowNotInCooldown = true

# Called when the node enters the scene tree for the first time.
func _ready():
	arrowMarker = get_node("../ArrowMarker") # Replace with function body.
	position = arrowMarker.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = arrowMarker.position
	
func SetFacing(setFacingModifier):
	facingModifier = setFacingModifier
	if arrowMarker != null:
		position = arrowMarker.position
	if facingModifier >= 0:
		rotation_degrees = 180
	else:
		rotation_degrees = 0
	
func StartFiring():
	if bowNotInCooldown:
		show()
		isFiring = true
		
		var newArrow = arrowScene.instantiate()
		newArrow.SetFacingModifier(facingModifier)
		newArrow.SetTotalDistance(10000)
		add_child(newArrow)
		if facingModifier >= 0:
			newArrow.rotation_degrees = 45
			rotation_degrees = 180
		else:
			newArrow.rotation_degrees = 225
			rotation_degrees = 0
		newArrow.position = arrowMarker.global_position
		
		bowNotInCooldown = false
		$BowCoolDownTimer.start()

func Firing():
	return isFiring

func _on_bow_cool_down_timer_timeout():
	bowNotInCooldown = true # Replace with function body.
	isFiring = false
	hide()