extends Node2D

onready var weapon = $Weapon
onready var parentus = get_parent()
const shot = preload("res://Scenes/Projectile/ShotFun.tscn")
const bomb = preload("res://Scenes/Projectile/Bomb.tscn")
const nuke = preload("res://Scenes/Projectile/Nuke.tscn")
var rng2 = RandomNumberGenerator.new()
var smgAmmo = 10

func _ready():
	rng2.randomize()

func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position() - global_position
	var angle = mouse_pos.angle()
	var r = global_rotation
	global_rotation = lerp_angle(r, angle, 1)

	if self.rotation_degrees < -90 or self.rotation_degrees > 90:
		weapon.flip_v = true
		weapon.rotation_degrees = -45
		weapon.position.y = 2
		$GUNHOLE.position.y = 2
		$MELEEHURTFIST.position.y = 2
		$MELEEHURTSAW.position.y = 2
		$MELEEHURTSWORD.position.y = 2
	else:
		weapon.flip_v = false
		weapon.rotation_degrees = 45
		weapon.position.y = -2
		$GUNHOLE.position.y = -2
		$MELEEHURTFIST.position.y = -2
		$MELEEHURTSAW.position.y = -2
		$MELEEHURTSWORD.position.y = -2
	weapons()


func weapons():
	var weaponCurrent = parentus.rngW
	if(parentus.rngN != 0):
		weapon.frame = weaponCurrent
	else:
		weapon.frame = 0
	if(parentus.rngN != 0):
		match(weaponCurrent):
			1:																																				#Fist
				if shootInput():
					$MELEEHURTFIST/CollisionShape2D.disabled = false
					$MeleeAttackSound.play()
					if(weapon.flip_v):
						$Gunimation.play("ThrustLeft")
					else:
						$Gunimation.play("ThrustRight")
			2:																																				#Saw
				if shootInput():
					$MeleeAttackSound.play()
					$MELEEHURTSAW/CollisionShape2D.disabled = false
					if(weapon.flip_v):
						$Gunimation.play("ThrustLeft")
					else:
						$Gunimation.play("ThrustRight")
			3:																																				#Sword
				if shootInput():
					$MeleeAttackSound.play()
					$MELEEHURTSWORD/CollisionShape2D.disabled = false
					if(weapon.flip_v):
						$Gunimation.play("ThrustLeft")
					else:
						$Gunimation.play("ThrustRight")
			4:																																				#Shotgun
				if shootInput():
					var shotG = [shot.instance(), shot.instance(), shot.instance(), shot.instance(), shot.instance(), shot.instance()]
					for counter in shotG.size():
						shotG[counter].position = $GUNHOLE.global_position
						shotG[counter].rotation_degrees = self.global_rotation_degrees + rng2.randi_range(-15, 15)
						shotG[counter]._shot_direction(get_global_mouse_position() + Vector2(rng2.randi_range(-15, 15), rng2.randi_range(-15, 15)))
						get_parent().get_parent().add_child(shotG[counter])
					parentus.velocity.x = 50 * weapon.position.y
					weaponUsage()
			5:																																				#SMG
				if shootInput():
					if(smgAmmo == 10):
						for counter in 10:
							var shotS = shot.instance()
							shotS.position = $GUNHOLE.global_position
							shotS.rotation_degrees = self.global_rotation_degrees
							shotS._shot_direction(get_global_mouse_position())
							get_parent().get_parent().add_child(shotS)
							yield(get_tree().create_timer(0.1), "timeout")
							smgAmmo -= 1
						weaponUsage()
						smgAmmo = 10
			6:																																				#Bomb
				if shootInput():
					var regularBomb = bomb.instance()
					regularBomb.position = $GUNHOLE.global_position
					regularBomb._throw_direction(get_global_mouse_position())
					get_parent().get_parent().add_child(regularBomb)
					weaponUsage()
			7:																																				#Nuke
				if shootInput():
					var regularNuke = nuke.instance()
					regularNuke.position = $GUNHOLE.global_position
					regularNuke._throw_direction(get_global_mouse_position())
					get_parent().get_parent().add_child(regularNuke)
					weaponUsage()

func shootInput():
	if Input.is_action_just_pressed("Shoot"):
		return true

func weaponUsage():
	if(parentus.rngN != 0):
		parentus.rngN -= 1
		parentus.numba.frame = parentus.rngN
		if(parentus.rngN == 0):
			parentus.rngW = 0
			parentus.weapon.frame = parentus.rngW

func _on_Gunimation_animation_finished(anim_name):
	if anim_name == "ThrustLeft" || anim_name == "ThrustRight":
		$MELEEHURTFIST/CollisionShape2D.disabled = true
		$MELEEHURTSAW/CollisionShape2D.disabled = true
		$MELEEHURTSWORD/CollisionShape2D.disabled = true
		weaponUsage()
