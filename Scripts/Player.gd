extends KinematicBody2D


onready var gun = $Position2D/gun
onready var gun_holder = $Position2D
var deg_for_bullet
export var MAX_SPEED = 350
export var ACCELERATION = 400
var motion = Vector2.ZERO

func _ready():

	Global.player = self
	
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	gun_stuff()
	var axis = get_input_axis()
	if axis == Vector2.ZERO :
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	
	motion = move_and_slide(motion)		

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO	
	
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func gun_stuff():
	var mouse_pos = Vector2()
	mouse_pos = get_global_mouse_position()	
	deg_for_bullet = mouse_pos.angle_to_point(gun.global_position)
	gun_holder.look_at(mouse_pos)
	if global_position.x > mouse_pos.x:
		gun.scale.y = - 1
	else:
		gun.scale.y = 1	
	
func kill():
	queue_free()
	get_tree().reload_current_scene()	
	



func _on_Hurtbox_area_entered(area):
	kill()
