extends Area2D
signal hit

var screen_size 
var leftTopEdge
var rightBottomEdge
var facingModifier
var swordIsAttacking
var swordNotInCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	leftTopEdge = Vector2(0, 0)
	rightBottomEdge = Vector2(screen_size[0] - 58, screen_size[1] - 60)
	facingModifier = -1
	swordIsAttacking = false
	swordNotInCooldown = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
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
	if Input.is_action_pressed("mouse_left_click") && swordNotInCooldown:
		$SpwpnSingingSword.show()
		swordIsAttacking = true
		
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
	
	if velocity.x != 0:
		var flip = velocity.x > 0
		$AnimatedSprite2D.flip_h = flip
		if flip:
			$SpwpnSingingSword.position.x = 58
			facingModifier = 1
		else:
			$SpwpnSingingSword.position.x = 8
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
