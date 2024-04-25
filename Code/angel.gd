extends Node2D

@export var swordScene: PackedScene
var mainCharacter
var swordWeapon
	
# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	swordWeapon = swordScene.instantiate()	
	swordWeapon.SetFacing(-1)
	swordWeapon.SetPositionSides(5, 40, -2)
	add_child(swordWeapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var facingModifier = -1
	var mainCharPos = mainCharacter.position
	if mainCharPos.x < position.x:
		$Angel.flip_h = true
		swordWeapon.SetFacing(facingModifier)
	else:
		$Angel.flip_h = false
		facingModifier = 1
		swordWeapon.SetFacing(1)
	var newPos = position.move_toward(mainCharPos, delta * 100)
	if newPos.distance_to(mainCharPos) > 70:
		position = newPos
	else:
		if newPos.distance_to(mainCharPos) < 30:
			position.x -= 30 * facingModifier
		if abs(newPos.y - mainCharPos.y) > 30:
			if newPos.y > mainCharPos.y:
				position.y -= 5
			else:
				position.y += 5
		swordWeapon.StartAttack()
