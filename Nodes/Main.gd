extends Node2D

signal gameovercito
const Player = preload("res://Nodes/Player.tscn")
const tronquito = preload("res://Nodes/Tronquito.tscn")
var jugadorl
var winTimes = 0
var lose = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$"CanvasLayer/Press Start".connect("start_pressed",self,"startgame")

func _process(delta):
	pass# Replace with function body.

func startgame():
	setWaveLabel()
	$CanvasLayer/WaveLabel.visible = true
	initPlayer()
	initTronquitos()
	print(get_tree().get_nodes_in_group("enemy").size())

func gameover():
	if get_tree().get_nodes_in_group("enemy").size() <=1: ## Siguiente Ola
		$CanvasLayer/AnimationPlayer.play("gameover")
		$CanvasLayer/ColorRect/wavesound.play()
		jugadorl.position = Vector2(240,122)
		jugadorl.set_physics_process(false)
		yield($CanvasLayer/AnimationPlayer,"animation_finished")
		jugadorl.set_physics_process(true)
		iGenerator.getItem("heart",Vector2(240,180),1)
		winTimes+=1
		setWaveLabel()
		initTronquitos()

func deathcito():
	$CanvasLayer/AnimationPlayer.play("Death")
	$CanvasLayer/ColorRect2/deathsound.play()
	$CanvasLayer/Button.visible = true
	lose = true
func setWaveLabel():
	$CanvasLayer/WaveLabel.text = str("Wave: ",str(winTimes+1))
func initPlayer():
	jugadorl = Player.instance()
	jugadorl.position = Vector2(240,122)
	$YSort.add_child(jugadorl)
	jugadorl.connect("death",self,"deathcito")
	
func initTronquitos():
	#var positions = PoolVector2Array([Vector2(67,165),Vector2(58,53),Vector2(251,210),Vector2(312,121),Vector2(402,126)])
	var positions = get_tree().get_nodes_in_group("enemy_spawn")
	for x in 5 + winTimes:
		var rand = randi() % positions.size()
		var tronquitont = tronquito.instance()
		tronquitont.position = positions[rand].position
		positions.remove(rand)
		tronquitont.upDificulty(winTimes)
		$YSort.add_child(tronquitont)
		tronquitont.connect("gameovercito",self,"gameover")

func dropTodo():
	for x in get_tree().get_nodes_in_group("enemy"):
		x.queue_free()
func _on_Button_pressed():
	$CanvasLayer/Button.visible = false
	if lose:
		$CanvasLayer/AnimationPlayer.play_backwards("Death")
		dropTodo()
		winTimes = 0
		setWaveLabel()
		initPlayer()
	else:
		$CanvasLayer/AnimationPlayer.play_backwards("gameover")
		jugadorl.set_physics_process(true)
		setWaveLabel()
	initTronquitos()
	lose = false
