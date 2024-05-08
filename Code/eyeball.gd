extends Area2D

@export var magicEffectScene: PackedScene

var mainCharacter
var facingModifier
var leftTopEdge
var rightBottomEdge
var magicNotInCooldown = true
var HP = 35
var notStunned = true

# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	facingModifier = -1
	leftTopEdge = mainCharacter.GetTopLeftBounds()
	rightBottomEdge = mainCharacter.GetBottomRightBounds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if notStunned:
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


func _on_area_entered(area):
	if area.name == "Player Sword" && area.Attacking():
		HP -= 50
		if HP > 0:
			$CollisionShape2D.set_deferred("disabled", true)
			if area.GetFacing() > 0:
				position.x += 50
			else:			
				position.x -= 50		
			position = position.clamp(leftTopEdge, rightBottomEdge)
			area.AddToPlayerHitList(self)
	else:
		if area.name == "Player Arrow": 
			HP -= 30
			area.Destroy()
			notStunned = false
			$StunnedTimer.start()
		else:
			if area.name == "Player Shockwave": 
				HP -= 35
				if area.position.x < position.x:
					position.x += area.GetDist() + 50
				else:
					position.x -= area.GetDist() + 50
				if area.position.y < position.y:
					position.y += area.GetDist() + 50
				else:
					position.y -= area.GetDist() + 50
				position = position.clamp(leftTopEdge, rightBottomEdge)
	if HP <= 0:
		mainCharacter.UpadateEnemiesDead()
		queue_free()

func _on_stunned_timer_timeout():
	notStunned = true
