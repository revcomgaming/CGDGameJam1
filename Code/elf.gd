extends Node2D

@export var bowScene: PackedScene
var mainCharacter
var bowWeapon
var facingModifier
var leftTopEdge
var rightBottomEdge

# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	facingModifier = -1
	bowWeapon = bowScene.instantiate()
	bowWeapon.SetFacing(facingModifier)
	add_child(bowWeapon)
	leftTopEdge = mainCharacter.GetTopLeftBounds()
	rightBottomEdge = mainCharacter.GetBottomRightBounds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mainCharPos = mainCharacter.position
	if mainCharPos.x > position.x:
		$Elf.flip_h = true
		facingModifier = 1
	else:
		$Elf.flip_h = false
		facingModifier = -1
	bowWeapon.SetFacing(facingModifier)
	if abs(position.y - mainCharacter.position.y) > 30:
		if position.y > mainCharacter.position.y:
			position.y -= 100 * delta
		else:
			position.y += 100 * delta
	else:
		if position.distance_to(mainCharPos) < 250:
			bowWeapon.StartFiring()		
	if position.distance_to(mainCharPos) < 30:
			position.x -= 30 * facingModifier
	position = position.clamp(leftTopEdge, rightBottomEdge)
