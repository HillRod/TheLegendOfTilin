extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal gameovercito
const Player = preload("res://Nodes/Player.tscn")
const tronquito = preload("res://Nodes/Tronquito.tscn")
var jugadorl
var lose = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initPlayer()
	initTronquitos()
	

func _process(delta):
	pass# Replace with function body.
	
func gameover():
	print(get_tree().get_nodes_in_group("enemy").size())
	
	if get_tree().get_nodes_in_group("enemy").size() <=1:
		$CanvasLayer/AnimationPlayer.play("gameover")
		print("game over")

func deathcito():
	$CanvasLayer/AnimationPlayer.play("Death")
	lose = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
		$YSort.add_child(tronquitont)
		tronquitont.connect("gameovercito",self,"gameover")
	
func dropTodo():
	for x in get_tree().get_nodes_in_group("enemy"):
		x.queue_free()
	

func _on_Button_pressed():
	if lose:
		$CanvasLayer/AnimationPlayer.play_backwards("Death")
		dropTodo()
	else:
		$CanvasLayer/AnimationPlayer.play_backwards("gameover")
		jugadorl.queue_free()
	initPlayer()
	initTronquitos()
	lose = false
