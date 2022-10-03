extends Node2D

export var max_hp = 100
var current_hp 
const bullet_scene = preload("res://Scenes/BossBullet.tscn")
signal killed
onready var shoot_timer = $ShootTimer
onready var rotator = $Rotator
onready var animation_player = $AnimationPlayer
onready var health_bar = $Control

var rotate_speed = 80
var shooter_timer_wait_time = 0.2
const spawn_point_count = 3
const radius = 100

func _ready():
	health_bar.on_max_health_updated(max_hp)
	Global.boss = self
	animation_player.play("BossMoving")
	current_hp = max_hp
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(i * step)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
		
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()
		
func _process(delta):
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)

func _on_ShootTimer_timeout():
	for i in rotator.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = i.global_position
		bullet.rotation = i.global_rotation
		


func _on_Hurtbox_area_entered(area):
	#animation_player.play("BossHurt")
	current_hp -= 1
	health_bar.on_health_updated(current_hp)
	if current_hp == 0:
		Kill()

func Kill():
	emit_signal("killed")
	queue_free()
	
	
