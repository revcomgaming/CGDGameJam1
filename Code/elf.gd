extends Node2D

@export var bowScene: PackedScene
var mainCharacter
var bowWeapon
var facingModifier

# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	facingModifier = -1
	bowWeapon = bowScene.instantiate()
	
	bowWeapon.SetFacing(facingModifier)
	add_child(bowWeapon)

func SetFacing(setFacingModifier):
	facingModifier = setFacingModifier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mainCharPos = mainCharacter.position
	if mainCharPos.x < position.x:
		$Elf.flip_h = true
		bowWeapon.SetFacing(facingModifier)
	else:
		$Elf.flip_h = false
		facingModifier = 1
	if abs(position.y - mainCharacter.position.y) > 30:
		if position.y > mainCharacter.position.y:
			position.y -= 50
		else:
			position.y += 50
	else:
		bowWeapon.StartFiring()
