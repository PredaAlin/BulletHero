extends Node2D

const Player = preload("res://Scenes/Player.tscn")
const ExitDoor = preload("res://Scenes/ExitDor.tscn")
const Enemy = preload("res://Scenes/enemy.tscn")
const Enemy1 = preload("res://Scenes/enemy2.tscn")

var borders = Rect2(1, 1, 76, 42)
var player = Player.instance()
onready var tileMap = $TileMap2
var counter = 0
var enemy_count = 0
var exit_created = true

func _ready():
	Global.world = self
	randomize()
	generate_level()

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet = preload("res://Scenes/bullet1.tscn").instance()
		bullet.rotation  = Global.player.deg_for_bullet
		bullet.global_position = $Player/Position2D/gun/muzzle.global_position
		
		add_child(bullet)
		
	if enemy_count == 0:
		var exit = ExitDoor.instance()
		
		add_child(exit)
		if exit_created:
			Global.level_cleared_counter += 1
			exit.position = get_global_mouse_position()
			if Global.level_cleared_counter == 3:
				exit.connect("leaving_level", self, "load_boss")
			else:	
				exit.connect("leaving_level", self, "reload_level")

			exit_created = false
			


func generate_level():
	
	
	var walker = Walker.new(Vector2(38, 21), borders)
	var map = walker.walk(100)
	
	
	add_child(player)
	player.position = map.front() * 64
	
	
	
	for room in walker.rooms:
		counter += 1
		if counter % 2 == 0:
			var enemy = Enemy1.instance()
			add_child(enemy)
			enemy.position = room.position * 64 + Vector2(randi()%20, randi()%20) 
			enemy_count += 1	
	print(enemy_count)		
	walker.queue_free() 
	
	
	
	
	for location in map:
		tileMap.set_cellv(location, -1)
	
	
	
	tileMap.update_bitmask_region(borders.position, borders.end)	

func reload_level():
	get_tree().reload_current_scene()

func load_boss():
	get_tree().change_scene("res://Scenes/BossRoom.tscn")	

func _input(event):	
	if event.is_action_pressed("ui_accept"):
		reload_level()
