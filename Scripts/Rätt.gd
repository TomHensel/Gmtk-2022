extends KinematicBody2D

onready var weapon = $Weaponry
onready var numba = $Numbars
onready var animatio = $AnimationPlayer
var health = 3
var speed = 150
var direction = 1
var jump = -150
var gravity = 300
var snap = Vector2(0, 16)
var acceleration = 10
var friction = 0.1
var velocity = Vector2()
var rng = RandomNumberGenerator.new()
var rngW = 0
var rngN = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _physics_process(delta: float):
	if health == 0:
		get_tree().reload_current_scene()
	global.playerPosition = global_position
	if !is_on_floor():
		velocity.y += gravity * delta
		snap = Vector2(0, 16)
		friction = 0.01
	input_check()
	velocity.y = move_and_slide_with_snap(velocity, snap, Vector2(0, -1)).y
	if is_on_ceiling() || is_on_floor():
		velocity.y = 0
		friction = 0.1
	if is_on_wall():
		velocity.x = 0

func input_check():
	if Input.is_action_pressed("Right"):
		direction = 1
		velocity.x = min(velocity.x + acceleration * direction, speed)
		animatio.play("WalkLeft")
	elif Input.is_action_pressed("Left"):
		direction = -1
		velocity.x = max(velocity.x + acceleration * direction, -speed)
		animatio.play("WalkRight")
	else:
		velocity.x = lerp(velocity.x , 0 , friction)
		if(direction == 1):
			animatio.play("IdleLeft")
		else:
			animatio.play("IdleRight")
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		snap = Vector2.ZERO
		velocity.y = jump
	if Input.is_action_just_pressed("Roll"):
		if(rngW == 0):
			rngW = rng.randi_range(1, 6)
			weapon.frame = rngW
			return 0
		if(rngW != 0 && rngN == 0):
			rngN = rng.randi_range(1, 6)
			if(rngN == 6 && rngW == 6):
				numba.frame = 1
				weapon.frame = 7
				rngW = 7
				rngN = 1
			else:
				numba.frame = rngN
		if(rngN != 0):
			weapon.frame = 0

func _on_Area2D_area_entered(area):
	if area.is_in_group("EnemyAttack"):
		$"Rätt/Hurt".visible = true
		yield(get_tree().create_timer(0.1), "timeout")
		$"Rätt/Hurt".visible = false
		health -= 1
		$"Rätt/Hat/Health".frame = health-1
	elif area.is_in_group("Sawblade"):
		health = 0
