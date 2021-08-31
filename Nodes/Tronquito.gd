extends KinematicBody2D

var velocity = 100
var DAMAGE = 1
var ani = "WDown"
var dir = Vector2(0,0) # Vector2.ZERO
var timerlimit = 30
var timer = 0
var _life = 2
var life
var random
var flame = preload("res://Nodes/Projectiles/Flame.tscn")
var esplosion = preload("res://Nodes/Projectiles/Explosion.tscn")
var cooldown = true
var verguiado = false
var target_player: bool = false
var target_pos: Vector2 = Vector2.ZERO
var angle
var dirs = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]#l, u, r, d
signal gameovercito()


func _ready():
	#random = randi()%20
	life = _life
	
func _physics_process(delta):
	#random = randi()%20
	
	if !verguiado:
		if !target_player: 
			passiveIA()
			movLoop()
		else:
			refresPlayerTarget()
			activeIA(target_pos)
		animLoop()
		timer+=1

func upDificulty(waveN): 
	_life+= waveN 
	life = _life
	#velocity = velocity * waveN
	if _life>=5: $cooldown.wait_time -= 1
	
func passiveIA():
	if timer >= timerlimit:
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
		
func activeIA(playerPos):
	
	var movement = position.direction_to(playerPos) * velocity * 1.3
	angle = rad2deg(movement.angle())
	if angle<0: angle+=360
	if angle>= 315: angle-=360
	var i = 0
	for x in [0,90,180,270]:
		if angle >= x-45 and angle < x+45:
			break
		i+=1
	dir = dirs[i]
	var _move = move_and_slide(movement) 
	var slide_count = get_slide_count()
	movement = _move

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
			var knockback = transform.origin-body.get_parent().transform.origin 
			move_and_slide(knockback.normalized()*velocity*20,Vector2.ZERO)
			$AniTronquito.play("Verguiade")
			yield($AniTronquito,"animation_finished")
			$Sprite.modulate = Color(1,1,1,1)
			verguiado = false
		else:
			
			#set_physics_process(false)
			$ColorRect.visible = false
			$ColorRect2.visible = false
			var explosion = esplosion.instance()
			explosion.position = position
			get_parent().add_child(explosion)
			queue_free()
			emit_signal("gameovercito")

func refresPlayerTarget():
	target_pos = get_tree().get_nodes_in_group("player")[0].position

func _on_cooldown_timeout():
	cooldown = false


func _on_DetectZone_body_entered(body):
	if body.is_in_group("player"):
		target_player = true


func _on_DetectZone_body_exited(body):
	if body.is_in_group("player"):
		target_player = false
