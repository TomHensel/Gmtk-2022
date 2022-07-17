extends RigidBody2D

var speed = 100
var Xdirection = 1
var Ydirection = 1

func _ready():
	$AnimationPlayer.play("Normal")
	linear_velocity.x += Xdirection * speed
	linear_velocity.y += Ydirection * speed


func _process(_delta):
	pass

func _throw_direction(mouse_pos):
	Xdirection = position.direction_to(mouse_pos).x
	Ydirection = position.direction_to(mouse_pos).y

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Enemy")):
		mode = 1
		$AnimationPlayer.play("Nukesplosion")

func _on_Area2D_body_entered(body):
	if(!body.is_in_group("Player") && !body.is_in_group("Bomb")):
		yield(get_tree().create_timer(3), "timeout")
		mode = 1
		$AnimationPlayer.play("Nukesplosion")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Nukesplosion":
		queue_free()
