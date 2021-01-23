extends KinematicBody2D

var _velocity = Vector2()
var _facing = Vector2()
var _speed = 50
var _speed_unit = 1.0

func _ready():
	$AnimatedSprite.play("idle_front")


func _process(delta):
	_inputCheck()
	move_and_slide(_velocity * _speed_unit * _speed)
	_animate()
	_velocity = Vector2.ZERO
	



func _inputCheck():
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
	
	_velocity = _velocity.normalized()
	_facing = _facing.normalized()


func _animate():
	if _velocity.length_squared() > 0:
		_playWalkAnimation()
	else:
		_playIdleAnimation()
	
	

func _playIdleAnimation():
	if _facing.x >= 1.0:
		$AnimatedSprite.play("idle_right")
	elif _facing.x <= -1.0:
		$AnimatedSprite.play("idle_left")
	elif _facing.y >= 1.0:
		$AnimatedSprite.play("idle_down")
	elif _facing.y <= -1.0:
		$AnimatedSprite.play("idle_up")


func _playWalkAnimation():
	if _facing.x >= 1.0:
			$AnimatedSprite.play("walk_right") 
	elif _facing.x <= -1.0:
			$AnimatedSprite.play("walk_left") 
	elif _facing.y >= 1.0:
			$AnimatedSprite.play("walk_down")
	elif _facing.y <= -1.0:
		$AnimatedSprite.play("walk_up")
