extends KinematicBody2D

const velocity = 100
const DAMAGE = 1
var ani = "WDown"
var dir = Vector2(0,0) # Vector2.ZERO
var timer = 0
var timerlimit = 30
var _life = 2
var life
var flame = preload("res://Nodes/Projectiles/Flame.tscn")
var cooldown = false
export var verguiado = false
signal gameovercito(tronsition)

func _ready():
	life = _life
	
func _physics_process(delta):
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
				if _life >=8: shoot()
				dir = Vector2(0,1)
			1:
				if _life >=7: shoot()
				dir = Vector2(1,0)
			2:
				if _life >=6: shoot()
				dir = Vector2(0,-1)
			3:
				if _life >=5: shoot()
				dir = Vector2(-1,0)
			4: 
				if _life >=4: shoot()
				dir = Vector2.ZERO
	#yield(get_tree().create_timer(2),"timeout")

func shoot():
	if cooldown:
		return
	else:
		cooldown = true
		$cooldown.start()
		var rand = randi()%4
		var _flame = flame.instance()
		var shoot
		match rand:
			0:
				shoot = "ShootDown"
			1:
				shoot = "ShootUp"
			2:
				shoot = "ShootLeft"
			3:
				shoot = "ShootRight"
		$Effects.play("prepareto")
		yield($Effects,"animation_finished")
		_flame.position = position
		add_child(_flame)
		_flame.aniP.play(shoot)
		yield(_flame.aniP,"animation_finished")
		_flame.queue_free()
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
			$CollisionPolygon2D.disabled = true
			$ColorRect.visible = false
			$ColorRect2.visible = false
			set_physics_process(false)
			$AniTronquito.play("Det")
			yield(get_tree().create_timer(1),"timeout")
			queue_free()
			emit_signal("gameovercito",position)
		


func _on_cooldown_timeout():
	cooldown = false
