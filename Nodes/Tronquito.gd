extends KinematicBody2D

const velocity = 100
var ani = "WDown"
var dir = Vector2(0,0) # Vector2.ZERO
var timer = 0
var timerlimit = 30
var life = 3
export var verguiado = false
signal gameovercito

func _physics_process(delta):
	if !verguiado:
		iaLoop()
		movLoop()
		animLoop()
	timer+=1

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
		
		$ColorRect.rect_size.x -= 6
		if life > 0:
			verguiado = true
			life-=1
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
			yield(get_tree().create_timer(1),"timeout")
			queue_free()
			emit_signal("gameovercito")
		
