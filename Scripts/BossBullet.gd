extends Node2D

const speed = 300

func _physics_process(delta):
	position += transform.x * speed * delta
	
	


func _on_Timer_timeout():
		queue_free()


func _on_BossBullet_area_entered(area):
	queue_free()


func _on_BossBullet_body_entered(body):
	queue_free()
