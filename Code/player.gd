extends Area2D
signal hit

@export var swordScene: PackedScene
@export var bowScene: PackedScene
@export var magicEffectScene: PackedScene
@export var angelEnemyScene: PackedScene
@export var elfEnemyScene: PackedScene

var screen_size 
var leftTopEdge
var rightBottomEdge
var swordWeapon
var bowWeapon
var facingModifier
var magicNotInCooldown

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
	swordWeapon.SetPositionSides(1, 50)
	add_child(swordWeapon)
	
	bowWeapon.SetFacing(facingModifier)
	add_child(bowWeapon)
	
	SpawnEnemy()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			var newMagicScene = magicEffectScene.instantiate()
			newMagicScene.SetStart(Vector2(position.x + 35, position.y + 35), 55)
			add_child(newMagicScene)
			magicNotInCooldown = false
			$MagicInUseCooldownTimer.start()
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
		
func SpawnEnemy():
	var angelEnemy = angelEnemyScene.instantiate()
	angelEnemy.position = Vector2(100, 400)
	add_child(angelEnemy)
	
	var elfEnemy = elfEnemyScene.instantiate()
	elfEnemy.position = Vector2(400, 300)
	add_child(elfEnemy)

func _on_body_entered(body):
	hide()
	hit.emit()
	$AnimatedSprite2D/CollisionShape2D.set_deferred("disabled", true)
	
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
