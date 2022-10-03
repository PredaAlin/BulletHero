extends KinematicBody2D
 
const MOVE_SPEED = 200
 
onready var raycast = $RayCast2D
onready var softCollision = $SoftCollision
onready var playerDetection = $PlayerDetectionZone
onready var healthBar = $Control
export var max_hp = 3
var current_hp 
var velocity = Vector2.ZERO
var playerEntered = null


enum{
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE
 
var player = null
 
func _ready():
	healthBar.on_max_health_updated(max_hp)
	current_hp = max_hp
	add_to_group("enemies")
	Global.enemy = self
 
func _physics_process(delta):
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 200
		
	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			player = playerEntered
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MOVE_SPEED, 200 * delta)
	velocity = move_and_slide(velocity)	
#	move_and_collide(velocity)		
 
func seek_player():
	if can_see_player():
		state = CHASE
func kill():
	queue_free()
 
func set_player(p):
	player = p
	
func onHit(damage):
	current_hp -= damage
	healthBar.on_health_updated(current_hp)	
	if current_hp <= 0:
		onDeath()

func onDeath():
	queue_free()
	Global.world.enemy_count -=1
	print(Global.world.enemy_count)
	


func _on_PlayerDetectionZone_body_entered(body):
	playerEntered = body


func _on_PlayerDetectionZone_body_exited(body):
	playerEntered = null
	
func can_see_player():
	return playerEntered!=null	
