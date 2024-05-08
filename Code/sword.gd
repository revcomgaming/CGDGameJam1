extends Area2D
signal hit

var facingModifier
var isAttacking = false
var swordNotInCooldown = true
var xPosLeftSide = 0
var xPosRightSide = 0
var isNotPlayer = true
var playerHitList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isAttacking && facingModifier != null:
		rotation_degrees += PI * 300 * delta * facingModifier
		if (facingModifier >= 1 && rotation_degrees > 135) || rotation_degrees < -225:
			hide()
			rotation_degrees = -45
			isAttacking = false
			for enemy in playerHitList:
				enemy.ResetCollision()
			playerHitList.clear()

func SetFacing(setFacingModifier):
	facingModifier = setFacingModifier
	if setFacingModifier > 0:
		position.x = xPosRightSide
	else:
		position.x = xPosLeftSide
		
func SetPositionSides(setXPosLeftSide, setXPosRightSide, setYPos):
	xPosLeftSide = setXPosLeftSide
	xPosRightSide = setXPosRightSide
	position.y = setYPos
	
func StartAttack():
	if swordNotInCooldown:
		show()
		if isNotPlayer:
			$CollisionShape2D.disabled = false
		isAttacking = true
		swordNotInCooldown = false
		$SwordAttackCoolDownTimer.start()
	
func DamageDone():	
	if isNotPlayer:
		$CollisionShape2D.set_deferred("disabled", true)
		
func Attacking():
	return isAttacking
	
func IsPlayer():
	name = "Player Sword"
	isNotPlayer = false
	set_collision_layer(2)
	$CollisionShape2D.disabled = false
	
func AddToPlayerHitList(enemy):
	playerHitList.append(enemy)
	
func GetFacing():
	return facingModifier
	
func _on_sword_attack_cool_down_timer_timeout():
	swordNotInCooldown = true
