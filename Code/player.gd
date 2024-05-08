extends Area2D

@export var swordScene: PackedScene
@export var bowScene: PackedScene
@export var magicEffectScene: PackedScene
@export var angelEnemyScene: PackedScene
@export var elfEnemyScene: PackedScene
@export var eyeEnemyScene: PackedScene

var screen_size 
var leftTopEdge
var rightBottomEdge
var swordWeapon
var bowWeapon
var facingModifier
var magicNotInCooldown
var HP = 100
var notStunned = true
var enemiesAlive = 0
var enemiesDead = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	leftTopEdge = Vector2(0, 0)
	rightBottomEdge = Vector2(screen_size[0] - 58, screen_size[1] - 60)
	swordWeapon = swordScene.instantiate()
	bowWeapon = bowScene.instantiate()
	facingModifier = -1
	magicNotInCooldown = true
	
	swordWeapon.SetFacing(facingModifier)
	swordWeapon.SetPositionSides(9, 57, 35)
	swordWeapon.IsPlayer()
	add_child(swordWeapon)
	
	bowWeapon.SetFacing(facingModifier)
	bowWeapon.IsPlayer()
	add_child(bowWeapon)
	
	SpawnEnemy()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HP > 0 && enemiesAlive > enemiesDead:
		if notStunned:
			var velocity = Vector2.ZERO
			var mouseLeftButtonClick = Input.is_action_pressed("mouse_left_click")
			var mouseRightButtonClick = Input.is_action_pressed("mouse_right_click")
			var swordIsAttacking = swordWeapon.Attacking()
			var bowIsFiring = bowWeapon.Firing()
			if Input.is_action_pressed("move_right"):
				velocity.x += 1
			if Input.is_action_pressed("move_left"):
				velocity.x -= 1
			if Input.is_action_pressed("move_down"):
				velocity.y += 1
			if Input.is_action_pressed("move_up"):
				velocity.y -= 1
			if velocity.length() > 0:
				velocity = velocity.normalized() * 400	

				#$AnimatedSprite2D.play()
		#	else:
				#$AnimatedSprite2D.stop()
				
			if mouseLeftButtonClick && mouseRightButtonClick:
				if magicNotInCooldown && !swordIsAttacking && !bowIsFiring:
					DoShockwave()
			else:
				if mouseLeftButtonClick && !bowIsFiring:
					swordWeapon.StartAttack()
				
				if mouseRightButtonClick && !swordIsAttacking:
					bowWeapon.StartFiring()
				
			position += velocity * delta
			position = position.clamp(leftTopEdge, rightBottomEdge)
			
			if velocity.x != 0:
				var flip = velocity.x > 0
				$AnimatedSprite2D.flip_h = flip
				if flip:
					$ArrowMarker.position.x = 55
					facingModifier = 1
				else:
					$ArrowMarker.position.x = 6
					facingModifier = -1
				swordWeapon.SetFacing(facingModifier)	
				bowWeapon.SetFacing(facingModifier)
		else:
			if (Input.is_action_pressed("mouse_left_click") && 
				Input.is_action_pressed("mouse_right_click")):
				notStunned = true
				$StunnedTimer.stop()
				DoShockwave()
	else:
		if enemiesAlive == enemiesDead:
			position = Vector2(0, 0)
			$Label.position = Vector2((rightBottomEdge.x / 2) - 150, (rightBottomEdge.y / 2) - 50)
			$Label.text = "YOU WIN!!!!"
			$Label.show()
			$Restart.position = Vector2((rightBottomEdge.x / 2) - 75, (rightBottomEdge.y / 2) + 35)
			$Restart.show()
			$Restart.disabled = false
			
			
func DoShockwave():
	var newMagicScene = magicEffectScene.instantiate()
	newMagicScene.SetStart(Vector2(position.x + 35, position.y + 35), 55)
	newMagicScene.IsPlayer()
	add_child(newMagicScene)
	magicNotInCooldown = false
	$MagicInUseCooldownTimer.start()
		
func SpawnEnemy():
	var rand = RandomNumberGenerator.new()
	var numOfEnemies = rand.randi_range(5, 10)
	var enemyTypes = [angelEnemyScene, elfEnemyScene, eyeEnemyScene]
	var enemy
	
	for index in numOfEnemies:
		enemy = enemyTypes[rand.randi_range(0, 2)].instantiate()
		enemy.position = Vector2(rand.randi_range(leftTopEdge.x, rightBottomEdge.x),
								 rand.randi_range(leftTopEdge.y + 100, rightBottomEdge.y));
		add_child(enemy)
		enemiesAlive += 1
		
func UpadateEnemiesDead():
	enemiesDead += 1
	
func GetTopLeftBounds():
	return leftTopEdge
	
func GetBottomRightBounds():
	return rightBottomEdge
	
func TakeDamage(damage):
	HP -= damage
	if HP <= 0:
		position = Vector2(0,0)
		$Label.position = Vector2((rightBottomEdge.x / 2) - 150, (rightBottomEdge.y / 2) - 50)
		$Label.show()
		$Restart.position = Vector2((rightBottomEdge.x / 2) - 75, (rightBottomEdge.y / 2) + 35)
		$Restart.show()
		$Restart.disabled = false
	queue_redraw()

func _draw():
	if HP > 0:
		draw_rect(Rect2(Vector2($Label2.position.x + 33, $Label2.position.y + 8), Vector2(110, 10)), 
				  Color.BLACK, 
				  true)
		draw_rect(Rect2(Vector2($Label2.position.x + 40, $Label2.position.y + 10), Vector2(HP, 5)), 
				  Color.GREEN, 
				  true)
	else:
		$Label2.hide()
#	hide()
	#hit.emit()
	#$AnimatedSprite2D/CollisionShape2D.set_deferred("disabled", true)
	
#func start(pos):
	#position = pos
	#show()
	#$AnimatedSprite2D/CollisionShape2D.disabled = false


#func _on_bow_in_use_cooldown_timeout():
#	bowIsFiring = false
#	bowNotInCooldown = true
#	$Longbow.hide()


func _on_magic_in_use_cooldown_timer_timeout():
	magicNotInCooldown = true

func _on_area_entered(area):
	if area.name == "Sword":
		TakeDamage(35)
		area.DamageDone()
		if area.GetFacing() > 0:
			position.x += 35
		else:			
			position.x -= 35		
		position = position.clamp(leftTopEdge, rightBottomEdge)
	else: 
		if area.name == "Arrow":
			TakeDamage(25)
			area.Destroy()
			notStunned = false
			$StunnedTimer.start()
		else: 
			if area.name == "Shockwave":
				TakeDamage(15)
				if area.position.x < position.x:
					position.x += area.GetDist()
				else:
					position.x -= area.GetDist()
				if area.position.y < position.y:
					position.y += area.GetDist()
				else:
					position.y -= area.GetDist()
				position = position.clamp(leftTopEdge, rightBottomEdge)

func _on_button_pressed():
	get_tree().reload_current_scene() # Replace with function body.

func _on_stunned_timer_timeout():
	notStunned = true
