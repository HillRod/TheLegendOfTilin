extends Area2D

export var DAMAGE = 1
onready var aniP = $AnimationPlayer
var speed = 100
var dir = Vector2.ZERO

func _physics_process(delta):
	position += dir * speed * delta

func _ready():
	aniP.play("Shoot")


func _on_DeadLine_timeout():
	$AnimationPlayer2.play("Det")
	$CollisionPolygon2D.disabled = true
	yield($AnimationPlayer2,"animation_finished")
	queue_free() 

func moveTo(vector):
	dir = vector
	rotation_degrees = rad2deg(dir.angle())


func _on_Flame_area_entered(area):
	print("ooofff")
	if area.is_in_group("player"):
		$AnimationPlayer2.play("Det")
		$CollisionPolygon2D.disabled = true
		yield($AnimationPlayer2,"animation_finished")
		queue_free()
