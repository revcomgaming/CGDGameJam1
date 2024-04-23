extends Area2D
signal hit

@export var arrowScene: PackedScene
@export var magicEffectScene: PackedScene

var screen_size 
var leftTopEdge
var rightBottomEdge
var facingModifier
var swordIsAttacking
var bowIsFiring
var swordNotInCooldown
var bowNotInCooldown
var magicNotInCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	leftTopEdge = Vector2(0, 0)
	rightBottomEdge = Vector2(screen_size[0] - 58, screen_size[1] - 60)
	facingModifier = -1
	swordIsAttacking = false
	bowIsFiring = false
	swordNotInCooldown = true
	bowNotInCooldown = true
	magicNotInCooldown = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var mouseLeftButtonClick = Input.is_action_pressed("mouse_left_click")
	var mouseRightButtonClick = Input.is_action_pressed("mouse_right_click")
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
		if mouseLeftButtonClick && swordNotInCooldown && !bowIsFiring:
			$SpwpnSingingSword.show()
			swordIsAttacking = true
		
		if mouseRightButtonClick && bowNotInCooldown && !swordIsAttacking:
			$Longbow.show()
			var newArrow = arrowScene.instantiate()
			newArrow.SetFacingModifier(facingModifier)
			newArrow.SetTotalDistance(10000)
			add_child(newArrow)
			if facingModifier >= 0:
				newArrow.rotation_degrees = 45
				$ArrowMarker.position.x = 55
			else:
				newArrow.rotation_degrees = 225
				$ArrowMarker.position.x = 6
			newArrow.position = $ArrowMarker.global_position
			bowIsFiring = true
		
	position += velocity * delta
	position = position.clamp(leftTopEdge, rightBottomEdge)
	
	if swordIsAttacking:
		$SpwpnSingingSword.rotation_degrees += PI * 300 * delta * facingModifier
		if (facingModifier >= 1 && $SpwpnSingingSword.rotation_degrees > 135) || $SpwpnSingingSword.rotation_degrees < -225:
			$SpwpnSingingSword.hide()
			$SpwpnSingingSword.rotation_degrees = -45
			swordIsAttacking = false
			swordNotInCooldown = false
			$SwordAttackCooldownTimer.start()
			
	if bowIsFiring:
		if bowNotInCooldown:
			bowNotInCooldown = false
			$BowInUseCooldownTimer.start()
	
	if velocity.x != 0:
		var flip = velocity.x > 0
		$AnimatedSprite2D.flip_h = flip
		if flip:
			$SpwpnSingingSword.position.x = 58
			$Longbow.position.x = 50
			$Longbow.rotation_degrees = -45
			facingModifier = 1
		else:
			$SpwpnSingingSword.position.x = 8
			$Longbow.position.x = 8
			$Longbow.rotation_degrees = -225
			facingModifier = -1

func _on_body_entered(body):
	hide()
	hit.emit()
	$AnimatedSprite2D/CollisionShape2D.set_deferred("disabled", true)
	
#func start(pos):
	#position = pos
	#show()
	#$AnimatedSprite2D/CollisionShape2D.disabled = false


func _on_sword_attack_cooldown_timer_timeout():
	swordNotInCooldown = true


func _on_bow_in_use_cooldown_timeout():
	bowIsFiring = false
	bowNotInCooldown = true
	$Longbow.hide()


func _on_magic_in_use_cooldown_timer_timeout():
	magicNotInCooldown = true
