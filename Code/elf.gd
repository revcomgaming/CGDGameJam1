extends Area2D

@export var bowScene: PackedScene
var mainCharacter
var bowWeapon
var facingModifier
var leftTopEdge
var rightBottomEdge
var HP = 50
var notStunned = true

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
	if notStunned:
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
				notStunned = false
				$StunnedTimer.start()
		position = position.clamp(leftTopEdge, rightBottomEdge)
	
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
