extends Area2D


var speed = 5
var Xdirection = 1
var Ydirection = 1

func _ready():
	pass
	
func _physics_process(_delta):
	position.x += Xdirection * speed
	position.y += Ydirection * speed
	
func _shot_direction(pos):
	Xdirection = position.direction_to(pos).x
	Ydirection = position.direction_to(pos).y


func _on_TurretBullet_body_entered(_body):
	queue_free()
