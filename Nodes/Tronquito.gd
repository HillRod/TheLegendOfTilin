extends KinematicBody2D

const velocity = 100
const DAMAGE = 1
var ani = "WDown"
var dir = Vector2(0,0) # Vector2.ZERO
var timer = 0
var timerlimit = 30
var _life = 2
var life
var random
var flame = preload("res://Nodes/Projectiles/Flame.tscn")
var cooldown = true
export var verguiado = false
signal gameovercito(tronsition)


func _ready():
	#random = randi()%20
	life = _life
	
func _physics_process(delta):
	#random = randi()%20
	if !verguiado:
		iaLoop()
		movLoop()
		animLoop()
	timer+=1

func upDificulty(waveN): 
	_life+= waveN 
	life = _life
	if _life>=5: $cooldown.wait_time -= 1
	
func iaLoop():
	if timer>=timerlimit:
		timer = 0
		var rand = randi()%5
		match rand:
			0:
				dir = Vector2(0,1)
			1:
				dir = Vector2(1,0)
			2:
				dir = Vector2(0,-1)
			3:
				dir = Vector2(-1,0)
			4: 
				dir = Vector2.ZERO
	#yield(get_tree().create_timer(2),"timeout")

func shoot(vector):
	if cooldown:
		return
	else:
		cooldown = true
		$cooldown.start()
		var _flame = flame.instance()
		if vector == Vector2.ZERO:
			match ani:
				"WDown":
					_flame.moveTo(Vector2(0,1))
				"WLeft":
					_flame.moveTo(Vector2(1,0))
				"WRight":
					_flame.moveTo(Vector2(-1,0))
				"WUp":
					_flame.moveTo(Vector2(0,-1))
		else:	_flame.moveTo(vector)
		$Effects.play("prepareto")
		yield($Effects,"animation_finished")
		_flame.position = position
		get_tree().get_nodes_in_group("Mundo")[0].add_child(_flame)
		$Effects.play_backwards("prepareto")
		yield($Effects,"animation_finished")
		
		
func movLoop():
	var mov = dir.normalized() * velocity
	move_and_slide(mov,Vector2.ZERO)	

func animLoop():
	match dir:
		Vector2(0,1):
			ani = "WDown"
		Vector2(1,0):
			ani = "WLeft"
		Vector2(-1,0):
			ani = "WRight"
		Vector2(0,-1):
			ani = "WUp"
	if randi()%20 == 0 and _life >=4:	shoot(dir)
	aniSwitch()
			
func aniSwitch():
	if $AniTronquito.current_animation != ani:
		#yield($AniPlayer,"animation_finished")
		$AniTronquito.play(ani)


func _on_Area2D_body_entered(body):
	if body.is_in_group("putazo"):
		$ColorRect.rect_size.x -= (24/(_life)) * body.DAMAGE
		life-=body.DAMAGE
		if life > 0:
			verguiado = true
			var knockback = transform.origin-body.transform.origin 
			move_and_slide(knockback.normalized()*velocity*20,Vector2.ZERO)
			$AniTronquito.play("Verguiade")
			yield(get_tree().create_timer(.5),"timeout")
			$Sprite.modulate = Color(1,1,1,1)
			verguiado = false
		else:
			$ColorRect.visible = false
			$ColorRect2.visible = false
			set_physics_process(false)
			$AniTronquito.play("Det")
			yield($AniTronquito,"animation_finished")
			queue_free()
			emit_signal("gameovercito",position)

func _on_cooldown_timeout():
	cooldown = false
