extends Node2D

signal gameovercito
const Player = preload("res://Nodes/Player.tscn")
const tronquito = preload("res://Nodes/Tronquito.tscn")
const lifeUp = preload("res://Nodes/Items/LifeUp.tscn")
var jugadorl
var winTimes = 0
var lose = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	setWaveLabel()
	initPlayer()
	initTronquitos()
	

func _process(delta):
	pass# Replace with function body.
	
func gameover(tronsition):
	if get_tree().get_nodes_in_group("enemy").size() <=1:
		#$CanvasLayer/AnimationPlayer.play("gameover")
		winTimes+=1
		jugadorl.position = Vector2(240,122)
		setWaveLabel()
		initTronquitos()
	else:
		var rand = randi() % 4
		print(rand)
		if rand == 1:
			var life = lifeUp.instance()
			life.position = tronsition
			$YSort.add_child(life)

func deathcito():
	$CanvasLayer/AnimationPlayer.play("Death")
	lose = true
func setWaveLabel():
	$CanvasLayer/WaveLabel.text = str("Wave: ",str(winTimes+1))
func initPlayer():
	jugadorl = Player.instance()
	jugadorl.position = Vector2(240,122)
	$YSort.add_child(jugadorl)
	jugadorl.connect("death",self,"deathcito")
	
func initTronquitos():
	var positions = PoolVector2Array([Vector2(67,165),Vector2(58,53),Vector2(251,210),Vector2(312,121),Vector2(402,126)])
	for x in positions.size():
		var tronquitont = tronquito.instance()
		tronquitont.position = positions[x]
		tronquitont.upDificulty(winTimes)
		$YSort.add_child(tronquitont)
		tronquitont.connect("gameovercito",self,"gameover")
	
func dropTodo():
	for x in get_tree().get_nodes_in_group("enemy"):
		x.queue_free()
	

func _on_Button_pressed():
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
