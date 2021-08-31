extends KinematicBody2D

const velocity = 200
var ani = "Down"
var dir = Vector2(0,0) # Vector2.ZERO
var hitted = false
var isAtacking = false
export var max_life = 4
var vida
onready var lifebar = $ColorRect
signal death

func _ready():
	vida = max_life

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept") and !isAtacking:
		aniSwitch("A")
		isAtacking = true
		$Espada/AnimationPlayer.play("Swing")
		yield(get_tree().create_timer(0.2),"timeout")
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
		damage(body)
		body.stunActiveIA()

func damage(body):
	vida-=body.DAMAGE
	if vida>0:
		hitted=true
		$ColorRect.rect_size.x -= (4.8*body.DAMAGE)
		var knockback = transform.origin-body.transform.origin 
		move_and_slide(knockback.normalized()*velocity*10,Vector2.ZERO)
	else:
		emit_signal("death")
		queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		damage(area)
