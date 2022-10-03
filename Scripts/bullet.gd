extends Area2D

export var SPEED = 500
var vel = Vector2.ZERO

func _ready():
	vel = Vector2(SPEED, 0).rotated(Global.player.deg_for_bullet)
	
func _process(delta):
	position += vel * delta


func _on_bullet1_body_entered(body):
	queue_free()

	if body.is_in_group("enemies"):
		body.onHit(1)


