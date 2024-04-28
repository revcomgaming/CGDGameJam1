extends Node2D

@export var magicEffectScene: PackedScene

var mainCharacter
var facingModifier
var leftTopEdge
var rightBottomEdge
var magicNotInCooldown = true

# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	facingModifier = -1
	leftTopEdge = mainCharacter.GetTopLeftBounds()
	rightBottomEdge = mainCharacter.GetBottomRightBounds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mainCharPos = mainCharacter.position
	if mainCharPos.x > position.x:
		$Eyeball.flip_h = true
		facingModifier = 1
	else:
		$Eyeball.flip_h = false	
		facingModifier = -1
	if magicNotInCooldown:
		var newPos = position.move_toward(mainCharPos, delta * 50)
		if newPos.distance_to(mainCharPos) > 55:
			position = newPos
		else:
			var newMagicScene = magicEffectScene.instantiate()
			newMagicScene.SetStart(Vector2(position.x, position.y), 55)
			newMagicScene.SetColor(Color.BLACK)
			add_child(newMagicScene)
			magicNotInCooldown = false
			$MagicInUseCooldownTimer.start()
		position = position.clamp(leftTopEdge, rightBottomEdge)

func _on_magic_in_use_cooldown_timer_timeout():
	magicNotInCooldown = true # Replace with function body.
