extends Area2D

var speed = 5
var Xdirection = 1
var Ydirection = 1

func _ready():
	pass
	
func _process(_delta):
	position.x += Xdirection * speed
	position.y += Ydirection * speed
	
func _shot_direction(mouse_pos):
	Xdirection = position.direction_to(mouse_pos).x
	Ydirection = position.direction_to(mouse_pos).y

func _on_ShotgunFun_area_entered(area):
	if area.is_in_group("Enemy"):
		queue_free()


func _on_ShotgunFun_body_entered(_body):
	queue_free()
