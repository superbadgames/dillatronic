extends KinematicBody2D

enum FACING { front, back, left, right }

export var _speed = 50.0
export(FACING) var _initialFacing = FACING.front

var _velocity: Vector2 = Vector2()
var _facing = FACING.front
var _attacking: bool = false
var _turn = false

onready var _animation = get_node("AnimatedSprite")

func Playing():
	return _turn

func _ready():
	_animation.connect("animation_finished", self, "_NextAnimation")
	_facing = _initialFacing
	_Animate()

func _process(delta):
	_InputCheck()
	move_and_slide(_velocity)
	_Animate()
	_velocity = Vector2.ZERO


func _Attack():
	print("ATTACK!")
	_attacking = true


func StartRound():
	_turn = true

func _EndRound():
	_turn = false


func _InputCheck():
	if _attacking:
		return
	
	if Input.is_action_pressed("move_up"):
		_velocity.y = -_speed
		_facing = FACING.back
	if Input.is_action_pressed("move_down"):
		_velocity.y = _speed
		_facing = FACING.front
	if Input.is_action_pressed("move_left"):
		_velocity.x = -_speed
		_facing = FACING.left
	if Input.is_action_pressed("move_right"):
		_velocity.x = _speed
		_facing = FACING.right
	
	if Input.is_action_just_pressed("attack"):
		_velocity = Vector2.ZERO
		_Attack()
	
	if Input.is_action_just_pressed("action"):
		_velocity = Vector2.ZERO
		_EndRound()
		
	if Input.is_action_just_pressed("cancel"):
		# Close the application now
		pass


func _Animate():
	if _attacking:
		_AttackAnimation()
	elif _velocity.length_squared() > 0:
		_WalkAnimation()
	else:
		_IdleAnimation()


func _AttackAnimation():
	match _facing:
		FACING.front:
			_animation.play("attack_front")
		FACING.back:
			_animation.play("attack_back")
		FACING.left:
			_animation.play("attack_left")
		FACING.right:
			_animation.play("attack_right")


func _WalkAnimation():
	match _facing:
		FACING.front:
			_animation.play("walk_front")
		FACING.back:
			_animation.play("walk_back")
		FACING.left:
			_animation.play("walk_left")
		FACING.right:
			_animation.play("walk_right")


func _IdleAnimation():
	match _facing:
		FACING.front:
			_animation.play("idle_front")
		FACING.back:
			_animation.play("idle_back")
		FACING.left:
			_animation.play("idle_left")
		FACING.right:
			_animation.play("idle_right")


func _NextAnimation():
	if _animation.animation == "attack_front" or \
	   _animation.animation == "attack_back" or \
	   _animation.animation == "attack_right" or \
	   _animation.animation == "attack_left" :
		_IdleAnimation()
# This may be a bad place. If anything else is found that needs to use
# the _attacking flag, this may need to be wrapped into a larger logic
		_attacking = false
		_EndRound()
