extends KinematicBody2D

const velocity = 200
var ani = "Down"
var dir = Vector2(0,0) # Vector2.ZERO
var hitted = false
var isAtacking = false
var vida = 3
signal death

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept") and !isAtacking:
		aniSwitch("A")
		isAtacking = true
		yield(get_tree().create_timer(0.6),"timeout")
		
		isAtacking = false
		return
		
	if hitted:
		$AniPlayer.play("Hitted")
		$Area2D/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(.5),"timeout")
		hitted=false
		$Sprite.modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(.5),"timeout")
		$Area2D/CollisionShape2D.disabled = false
		return
	elif !isAtacking:
		controlLoop()
		aniSwitch("W")
		movLoop()
	animLoop()

func controlLoop():
	var U = Input.is_action_pressed("ui_up")
	var D = Input.is_action_pressed("ui_down")
	var L = Input.is_action_pressed("ui_left")
	var R = Input.is_action_pressed("ui_right")
	 
	dir.x = -int(L)+int(R)
	dir.y = -int(U)+int(D)
	
func movLoop():
	var mov = dir.normalized() * velocity
	move_and_slide(mov,Vector2.ZERO)	

func animLoop():
	match dir:
		Vector2(0,1):
			ani = "Down"
		Vector2(1,0):
			ani = "Right"
		Vector2(-1,0):
			ani = "Left"
		Vector2(0,-1):
			ani = "Up"
	

func aniSwitch(type):
	var anita = str(type,ani)
	if $AniPlayer.current_animation != anita:
		$AniPlayer.play(anita)
		yield($AniPlayer,"animation_finished")
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if vida>=0:
			hitted=true
			#print(vida)
			$ColorRect.rect_size.x -= 4.8
			var knockback = transform.origin-body.transform.origin 
			move_and_slide(knockback.normalized()*velocity*10,Vector2.ZERO)
			vida-=1
			
		else:
			emit_signal("death")
			queue_free()

