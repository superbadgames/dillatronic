extends KinematicBody2D

var _velocity: Vector2 = Vector2()
var _facing: Vector2 = Vector2()
var _speed: float = 50.0
var _speed_unit: float = 1.0
var _attacking: bool = false

onready var _animation = get_node("AnimatedSprite")

func _ready():
	_animation.connect("animation_finished", self, "_PlayNextAnimation")
	_animation.play("idle_front")


# warning-ignore:unused_argument
func _process(delta):
	_InputCheck()
# warning-ignore:return_value_discarded
	move_and_slide(_velocity * _speed_unit * _speed)
	_Animate()
	_velocity = Vector2.ZERO
	


func _InputCheck():
# Need to give the attack animation time to finish before any more input is
# considered.
	if _attacking:
		return
	
	if Input.is_action_pressed("move_up"):
		_velocity.y = -1.0
		_facing = Vector2.ZERO
		_facing.y = -1.0
	if Input.is_action_pressed("move_down"):
		_velocity.y = 1.0
		_facing = Vector2.ZERO
		_facing.y = 1.0
	if Input.is_action_pressed("move_right"):
		_velocity.x = 1.0
		_facing = Vector2.ZERO
		_facing.x = 1.0
	if Input.is_action_pressed("move_left"):
		_velocity.x = -1.0
		_facing = Vector2.ZERO
		_facing.x = -1.0
	
	if Input.is_action_pressed("attack"):
		_velocity = Vector2.ZERO
		_Attack()
		
	
	_velocity = _velocity.normalized()
	_facing = _facing.normalized()


func _Animate():
	if _attacking:
		_PlayAttackAnimation()
		return
	
	if _velocity.length_squared() > 0:
		_PlayWalkAnimation()
	else:
		_PlayIdleAnimation()
	

func _PlayIdleAnimation():
	if _facing.x >= 1.0:
		_animation.play("idle_right")
	elif _facing.x <= -1.0:
		_animation.play("idle_left")
	elif _facing.y >= 1.0:
		_animation.play("idle_down")
	elif _facing.y <= -1.0:
		_animation.play("idle_up")


func _PlayWalkAnimation():
	if _facing.x >= 1.0:
			_animation.play("walk_right") 
	elif _facing.x <= -1.0:
			_animation.play("walk_left") 
	elif _facing.y >= 1.0:
			_animation.play("walk_down")
	elif _facing.y <= -1.0:
		_animation.play("walk_up")
		


func _PlayAttackAnimation():
	if _facing.x >= 1.0:
			_animation.play("attack_right") 
	elif _facing.x <= -1.0:
			_animation.play("attack_left") 
	elif _facing.y >= 1.0:
			_animation.play("attack_down")
	elif _facing.y <= -1.0:
		_animation.play("attack_up")


func _PlayNextAnimation():
	if _animation.animation == "attack_up" or \
	_animation.animation == "attack_down" or \
	_animation.animation == "attack_right" or \
	_animation.animation == "attack_left" :
		_PlayIdleAnimation()
# This may be a bad place. If anything else is found that needs to use
# the _attacking flag, this may need to be wrapped into a larger logic
		_attacking = false


func _Attack():
	_attacking = true;
