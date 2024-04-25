extends Node2D

var facingModifier
var isAttacking = false
var swordNotInCooldown = true
var xPosLeftSide = 0
var xPosRightSide = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isAttacking && facingModifier != null:
		$SpwpnSingingSword.rotation_degrees += PI * 300 * delta * facingModifier
		if (facingModifier >= 1 && $SpwpnSingingSword.rotation_degrees > 135) || $SpwpnSingingSword.rotation_degrees < -225:
			hide()
			$SpwpnSingingSword.rotation_degrees = -45
			isAttacking = false

func SetFacing(setFacingModifier):
	facingModifier = setFacingModifier
	if setFacingModifier > 0:
		position.x = xPosRightSide
	else:
		position.x = xPosLeftSide
		
func SetPositionSides(setXPosLeftSide, setXPosRightSide, setYPos = null):
	xPosLeftSide = setXPosLeftSide
	xPosRightSide = setXPosRightSide
	if setYPos != null:
		position.y = setYPos
	
func StartAttack():
	if swordNotInCooldown:
		show()
		isAttacking = true
		swordNotInCooldown = false
		$SwordAttackCoolDownTimer.start()
	
func Attacking():
	return isAttacking

func _on_sword_attack_cool_down_timer_timeout():
	swordNotInCooldown = true
