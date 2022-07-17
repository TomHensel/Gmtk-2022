extends StaticBody2D

var player_in_range = false

var health = 4

onready var animatio = $AnimationPlayer
const bullet = preload("res://Scenes/Projectile/TurretBullet.tscn")

func _ready():
	animatio.play("Idle")

func _physics_process(_delta):
	if health <= 1:
		animatio.play("Dying")
		$CollisionShape2D.disabled = true
		$Hitbox.monitoring = false
		$Hitbox.monitorable = false
	if player_in_range:
		var player_pos = global.playerPosition - global_position
		var angle = player_pos.angle()
		var r = global_rotation
		global_rotation = lerp_angle(r, angle, 0.05)



func _on_PlayerDetector_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player_in_range = true


func _on_PlayerDetector_area_exited(area):
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player_in_range = false


func _on_Timer_timeout():
	if player_in_range:
		var shoot_bullet = bullet.instance()
		shoot_bullet.position = $Area2D.global_position
		shoot_bullet.rotation_degrees = self.global_rotation_degrees
		shoot_bullet._shot_direction($Area2D2.global_position)
		get_parent().add_child(shoot_bullet)


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Bullet"):
		animatio.play("Getting_Hit")
		$HurtSound.play()
		health -= 1
	if area.is_in_group("Explo"):
		animatio.play("Getting_Hit")
		$HurtSound.play()
		health -= health
	if area.is_in_group("Fist"):
		animatio.play("Getting_Hit")
		$HurtSound.play()
		health -= 3
	if area.is_in_group("Saw"):
		animatio.play("Getting_Hit")
		$HurtSound.play()
		health -= 5
	if area.is_in_group("Sword"):
		animatio.play("Getting_Hit")
		$HurtSound.play()
		health -= 10


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Getting_Hit":
		animatio.play("Idle")
	if anim_name == "Dying":
		queue_free()
