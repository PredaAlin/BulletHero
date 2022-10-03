extends Node2D

const ExitDoor = preload("res://Scenes/ExitDor.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet = preload("res://Scenes/bullet1.tscn").instance()
		if $Player.deg_for_bullet:
			bullet.rotation  = $Player.deg_for_bullet
			bullet.global_position = $Player/Position2D/gun/muzzle.global_position
			add_child(bullet)
		
	
	
		
