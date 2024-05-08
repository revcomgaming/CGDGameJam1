extends Area2D

@export var swordScene: PackedScene
var mainCharacter
var swordWeapon
var leftTopEdge
var rightBottomEdge
var HP = 100
var notStunned = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	mainCharacter = get_node("/root/Player")
	swordWeapon = swordScene.instantiate()	
	swordWeapon.SetFacing(-1)
	swordWeapon.SetPositionSides(13, 49, 33)
	add_child(swordWeapon)
	leftTopEdge = mainCharacter.GetTopLeftBounds()
	rightBottomEdge = mainCharacter.GetBottomRightBounds()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if notStunned:
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
		if newPos.distance_to(mainCharPos) > 60:
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
		position = position.clamp(leftTopEdge, rightBottomEdge)
	
func ResetCollision():
	$CollisionShape2D.disabled = false

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
