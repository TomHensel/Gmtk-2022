extends KinematicBody2D


var vel = Vector2()

var gravity = 600
var speed = 50
var Xdirection = -1
var player_position = Vector2()
var health = 10

onready var PlayerDetector = $PlayerDetector
onready var GroundDetector = $GroundDetector
onready var animatio = $AnimationPlayer

enum State {
	IDLE,
	RUN,
	ATTACK,
	GETTING_HIT,
	DYING
}

var State_ = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	if State_ == State.IDLE:
		switch_to_idle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if health <= 1:
		switch_to_Dying()
	
	State_Machine()
	
	detect_turn_around()
	
	vel.y += gravity * delta
	
	move_in_direction()
	
	#print(Xdirection)
	#print(State_)
	
	vel = move_and_slide(vel, Vector2.UP)
	
	
	
	
func move_in_direction():
	vel.x = Xdirection * speed
	
func detect_turn_around():
	if (not GroundDetector.is_colliding() and is_on_floor() or is_on_wall()):
		#print("turn around")
		switch_to_idle()
		scale.x = -scale.x
		Xdirection = -Xdirection

func detect_player():
	if PlayerDetector.is_colliding():
		var Collider = PlayerDetector.get_collider()
		if Collider.is_in_group("Player"):
			player_position = PlayerDetector.get_collision_point()
			switch_to_run()
			
func State_Machine():
	match(State_):
		State.IDLE:
			animatio.play("Walk")
			detect_player()
			pass
		State.RUN:
			animatio.play("Walk")
			var Player_Direction = position.direction_to(player_position).x
			if Player_Direction < 0:
				Xdirection = -1
			else:
				Xdirection = 1
			if not PlayerDetector.is_colliding():
				print("test")
				switch_to_idle()
		State.ATTACK:
			animatio.play("Attack")
			#print("Attack")
			#switch_to_idle()
		State.GETTING_HIT:
			animatio.play("Getting_Hit")
		State.DYING:
			$CollisionShape2D.disabled = true
			$Hitbox.monitoring = false
			$Hitbox.monitorable = false
			gravity = 0
			animatio.play("Dying")
			

func switch_to_idle():
	speed = 20
	State_ = State.IDLE
	
func switch_to_run():
	speed = 50
	State_ = State.RUN
	
func switch_to_Attack():
	speed = 0
	State_ = State.ATTACK
	
func switch_to_Getting_Hit():
	speed = 0
	$HurtSound.play()
	State_ = State.GETTING_HIT
	
func switch_to_Dying():
	speed = 0
	State_ = State.DYING
	
	
func hit():
	$AttackArea.visible = true
	$AttackArea.monitoring = true
	$AttackArea.monitorable = true
	
func end_of_hit():
	$AttackArea.monitorable = false
	$AttackArea.monitoring = false
	$AttackArea.visible = false

func _on_AttackRangeDetector_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		if State_ != State.ATTACK or State_ != State.GETTING_HIT:
			switch_to_Attack()



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		switch_to_idle()
	if anim_name == "Getting_Hit":
		switch_to_idle()
	if anim_name == "Dying":
			queue_free()


func _on_AttackArea_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		print("do damage")


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Bullet"):
		health -= 1
		#print(health)
		if State_ != State.ATTACK:
			switch_to_Getting_Hit()
		
